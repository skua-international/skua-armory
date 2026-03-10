mod types;

pub fn group() -> arma_rs::Group {
    arma_rs::Group::new()
        .command("grant", grant_certification)
        .command("revoke", revoke_certification)
        .command("load", load_player_certifications)
        .command("list", list_certifications)
}

use crate::database::get_client;
use crate::error::{QueryResult, transient_error};
use crate::{RUNTIME, domain::PlayerId};
use arma_rs::Context;
use tracing::instrument;
use types::{Certification, CertificationId};

/// Grant a certification to a player.
fn grant_certification(player_id: PlayerId, id: CertificationId) -> QueryResult {
    RUNTIME.spawn(async move {
        let result = grant_certification_db(player_id, &id).await;

        if let Err(e) = result {
            tracing::error!(player_id = ?player_id, cert_id = ?id, error = ?e, "Failed to grant certification");
        }
    });
    QueryResult::processing()
}

/// Grants a certification to a player in the database.
#[instrument(level = "debug", name = "grant_certification_db")]
async fn grant_certification_db(
    player_id: PlayerId,
    cert_id: &CertificationId,
) -> Result<(), QueryResult> {
    let client = match get_client().await {
        Ok(c) => c,
        Err(e) => return Err(transient_error("Failed to get database client", e)),
    };

    let sql = r#"
        INSERT INTO skua_master.player_certs (steam_id, cert_id)
        VALUES ($1, $2)
        ON CONFLICT DO NOTHING
    "#;
    let steam_id = player_id.as_i64();
    if let Err(e) = client.execute(sql, &[&steam_id, &cert_id]).await {
        return Err(transient_error(
            "Failed to grant certification in database",
            e,
        ));
    }
    Ok(())
}

/// Load all certifications for a player.
/// Calls back to Arma to raise an event to set the player's certifications.
fn load_player_certifications(ctx: Context, player_id: PlayerId) -> QueryResult {
    RUNTIME.spawn(async move {
        let result = get_player_certifications(player_id).await;

        let callback_result = match result {
            Ok(certs) => ctx.callback_data("skua:certification", "load", certs),
            Err(query_result) => ctx.callback_data("skua:certification", "load", query_result),
        };

        if let Err(e) = callback_result {
            // Log the error but do not return a failure to Arma, as the player can still play without certifications.
            tracing::error!(player_id = ?player_id, error = ?e, "Failed to callback player certifications");
        }
    });

    QueryResult::processing()
}

/// Revoke a certification from a player.
fn revoke_certification(player_id: PlayerId, id: CertificationId) -> QueryResult {
    RUNTIME.spawn(async move {
        let result = revoke_certification_db(player_id, &id).await;

        if let Err(e) = result {
            tracing::error!(player_id = ?player_id, cert_id = ?id, error = ?e, "Failed to revoke certification");
        }
    });

    QueryResult::processing()
}

async fn revoke_certification_db(
    player_id: PlayerId,
    cert_id: &CertificationId,
) -> Result<(), QueryResult> {
    let client = match get_client().await {
        Ok(c) => c,
        Err(e) => return Err(transient_error("Failed to get database client", e)),
    };

    let sql = r#"
        DELETE FROM skua_master.player_certs
        WHERE steam_id = $1 AND cert_id = $2
    "#;
    let steam_id = player_id.as_i64();
    if let Err(e) = client.execute(sql, &[&steam_id, &cert_id]).await {
        return Err(transient_error(
            "Failed to revoke certification in database",
            e,
        ));
    }
    Ok(())
}

/// List all available certifications.
/// Blocking. Do once at server startup. Refresh manually with event via Debug Console if needed.
fn list_certifications() -> Result<Vec<Certification>, QueryResult> {
    RUNTIME.block_on(list_certifications_db())
}

async fn list_certifications_db() -> Result<Vec<Certification>, QueryResult> {
    let client = match get_client().await {
        Ok(c) => c,
        Err(e) => return Err(transient_error("Failed to get database client", e)),
    };

    let sql = r#"
        SELECT id, display_name, document
        FROM skua_master.certifications
    "#;

    let rows = match client.query(sql, &[]).await {
        Ok(rows) => rows,
        Err(e) => return Err(transient_error("Failed to query certifications", e)),
    };

    let certifications: Vec<Certification> = rows
        .iter()
        .map(|row| Certification {
            id: row.get("id"),
            display_name: row.get("display_name"),
            document: row.get("document"),
        })
        .collect();

    Ok(certifications)
}

/// Get all certifications for a player.
#[instrument(level = "debug", name = "get_player_certifications")]
async fn get_player_certifications(player_id: PlayerId) -> Result<Vec<Certification>, QueryResult> {
    let client = match get_client().await {
        Ok(c) => c,
        Err(e) => return Err(transient_error("Failed to get database client", e)),
    };

    let sql = r#"
        SELECT c.id, c.display_name, c.document
        FROM skua_master.player_certs pc
        JOIN skua_master.certifications c ON pc.cert_id = c.id
        WHERE pc.steam_id = $1
    "#;

    let steam_id = player_id.as_i64();
    let rows = match client.query(sql, &[&steam_id]).await {
        Ok(rows) => rows,
        Err(e) => return Err(transient_error("Failed to query player certifications", e)),
    };

    let certifications: Vec<Certification> = rows
        .iter()
        .map(|row| Certification {
            id: row.get("id"),
            display_name: row.get("display_name"),
            document: row.get("document"),
        })
        .collect();

    Ok(certifications)
}
