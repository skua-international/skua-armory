// src/extension_new/domain/ids.rs
//
// Identifier types for domain entities.

use std::fmt::Display;

use arma_rs::{FromArma, IntoArma};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Steam ID for a player.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, FromArma, Serialize, Deserialize)]
pub struct PlayerId(u64);

impl Display for PlayerId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl From<u64> for PlayerId {
    fn from(value: u64) -> Self {
        PlayerId(value)
    }
}

impl From<PlayerId> for u64 {
    fn from(value: PlayerId) -> Self {
        value.0
    }
}

impl From<String> for PlayerId {
    fn from(value: String) -> Self {
        PlayerId(value.parse().unwrap_or(0))
    }
}

impl IntoArma for PlayerId {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::String(self.0.to_string())
    }
}

/// Campaign identifier.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, FromArma, Serialize, Deserialize)]
pub struct CampaignId(Uuid);

impl From<Uuid> for CampaignId {
    fn from(value: Uuid) -> Self {
        CampaignId(value)
    }
}

impl From<String> for CampaignId {
    fn from(value: String) -> Self {
        CampaignId(value.parse().unwrap_or(Uuid::nil()))
    }
}

impl From<CampaignId> for String {
    fn from(value: CampaignId) -> Self {
        value.0.to_string()
    }
}

impl IntoArma for CampaignId {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::String(self.0.to_string())
    }
}

/// Session identifier.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, FromArma, Serialize, Deserialize)]
pub struct SessionId(Uuid);

impl From<Uuid> for SessionId {
    fn from(value: Uuid) -> Self {
        SessionId(value)
    }
}

impl From<String> for SessionId {
    fn from(value: String) -> Self {
        SessionId(value.parse().unwrap_or(Uuid::nil()))
    }
}

impl From<SessionId> for String {
    fn from(value: SessionId) -> Self {
        value.0.to_string()
    }
}

impl IntoArma for SessionId {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::String(self.0.to_string())
    }
}
