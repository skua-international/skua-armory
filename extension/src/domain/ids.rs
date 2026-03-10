// src/extension/domain/ids.rs
//
// Identifier types for domain entities.

use std::fmt::Display;

use arma_rs::{FromArma, IntoArma};
use serde::{Deserialize, Serialize};
use tokio_postgres::types::ToSql;
use uuid::Uuid;

/// Steam ID for a player.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, FromArma, Serialize, Deserialize)]
pub struct PlayerId(u64);

impl Display for PlayerId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl PlayerId {
    /// Returns the Steam ID as an i64 for database queries expecting BIGINT.
    pub fn as_i64(&self) -> i64 {
        self.0 as i64
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

impl From<PlayerId> for String {
    fn from(value: PlayerId) -> Self {
        value.0.to_string()
    }
}

impl IntoArma for PlayerId {
    fn to_arma(&self) -> arma_rs::Value {
        arma_rs::Value::String(self.0.to_string())
    }
}

impl ToSql for PlayerId {
    fn to_sql(
        &self,
        ty: &tokio_postgres::types::Type,
        out: &mut tokio_postgres::types::private::BytesMut,
    ) -> Result<tokio_postgres::types::IsNull, Box<dyn std::error::Error + Sync + Send>>
    where
        Self: Sized,
    {
        <String as ToSql>::to_sql(&self.0.to_string(), ty, out)
    }

    fn accepts(ty: &tokio_postgres::types::Type) -> bool
    where
        Self: Sized,
    {
        <String as ToSql>::accepts(ty)
    }

    fn to_sql_checked(
        &self,
        ty: &tokio_postgres::types::Type,
        out: &mut tokio_postgres::types::private::BytesMut,
    ) -> Result<tokio_postgres::types::IsNull, Box<dyn std::error::Error + Sync + Send>> {
        <String as ToSql>::to_sql_checked(&self.0.to_string(), ty, out)
    }
}

/// Campaign identifier.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, FromArma, Serialize, Deserialize)]
pub struct CampaignId(Uuid);

impl CampaignId {
    /// Returns true if this is the nil UUID (no campaign).
    pub fn is_nil(&self) -> bool {
        self.0.is_nil()
    }

    /// Returns the schema key format (hyphens replaced with underscores).
    pub fn to_schema_key(&self) -> String {
        self.0.to_string().replace('-', "_")
    }
}

impl From<Uuid> for CampaignId {
    fn from(value: Uuid) -> Self {
        CampaignId(value)
    }
}

impl From<CampaignId> for Uuid {
    fn from(value: CampaignId) -> Self {
        value.0
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
