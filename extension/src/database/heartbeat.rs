// src/extension/database/heartbeat.rs
//
// Background heartbeat task for keeping the session alive.

use std::sync::OnceLock;
use std::time::Duration;

use tokio::sync::watch;
use tracing::{debug, error, info, warn};

use super::pool::get_client;
use crate::core::SESSION_ID;

/// Heartbeat interval - how often to update the session heartbeat.
const HEARTBEAT_INTERVAL: Duration = Duration::from_secs(60);

/// Global shutdown signal sender.
static SHUTDOWN_TX: OnceLock<watch::Sender<bool>> = OnceLock::new();

/// Starts the background heartbeat task.
///
/// This should be called once after bootstrap completes successfully.
/// The task runs until `stop()` is called or the runtime shuts down.
pub fn start() {
    let (tx, rx) = watch::channel(false);

    // Store the sender so we can signal shutdown later
    if SHUTDOWN_TX.set(tx).is_err() {
        warn!("heartbeat task already started");
        return;
    }

    crate::core::RUNTIME.spawn(heartbeat_loop(rx));
    info!("heartbeat task started");
}

/// Stops the background heartbeat task.
///
/// This should be called when ending the session.
pub fn stop() {
    if let Some(tx) = SHUTDOWN_TX.get() {
        let _ = tx.send(true);
        info!("heartbeat task stopped");
    }
}

/// The heartbeat loop - runs until shutdown is signaled.
async fn heartbeat_loop(mut shutdown: watch::Receiver<bool>) {
    let session_id = *SESSION_ID;

    loop {
        tokio::select! {
            // Check for shutdown signal
            _ = shutdown.changed() => {
                if *shutdown.borrow() {
                    debug!("heartbeat received shutdown signal");
                    break;
                }
            }
            // Wait for the interval
            _ = tokio::time::sleep(HEARTBEAT_INTERVAL) => {
                if let Err(e) = do_heartbeat(&session_id).await {
                    error!(error = %e, "heartbeat failed");
                }
            }
        }
    }
}

/// Performs a single heartbeat update.
async fn do_heartbeat(session_id: &uuid::Uuid) -> Result<(), String> {
    let client = get_client()
        .await
        .map_err(|e| format!("Failed to get client: {}", e))?;

    let sql = "UPDATE skua_master.sessions SET is_active = TRUE WHERE session_id = $1";
    client
        .execute(sql, &[session_id])
        .await
        .map_err(|e| format!("Failed to update heartbeat: {}", e))?;

    debug!(session_id = %session_id, "heartbeat sent");
    Ok(())
}
