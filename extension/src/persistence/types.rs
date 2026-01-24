// src/extension_new/persistence/types.rs
//
// Types for persisted game objects.

use arma_rs::{FromArma, IntoArma, loadout::Loadout};
use serde::{Deserialize, Serialize};
use serde_json::Value as JsonValue;
use uuid::Uuid;

use crate::domain::PlayerId;

/// Wrapper for Arma loadouts with serde support.
#[derive(Debug, FromArma)]
pub struct LoadoutWrapper(pub Loadout);

impl Serialize for LoadoutWrapper {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let json_value = self.0.to_arma().to_json();
        json_value.serialize(serializer)
    }
}

impl<'de> Deserialize<'de> for LoadoutWrapper {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let json_value = JsonValue::deserialize(deserializer)?;
        let string = json_value.to_string();
        let loadout = Loadout::from_arma(string).map_err(serde::de::Error::custom)?;
        Ok(LoadoutWrapper(loadout))
    }
}

/// Base data common to all persisted objects.
#[derive(Debug, Serialize, Deserialize, FromArma)]
pub struct ObjectData {
    pub name: String,
    pub uuid: Uuid,
    pub classname: String,
    pub position: (f64, f64, f64),
    pub orientation: ((f64, f64, f64), (f64, f64, f64)),
    pub direction: f64,
    pub last_world: String,
}

/// Position and orientation data for an object.
/// Used for serialization.
#[derive(Debug, Serialize, Deserialize)]
pub struct ObjectPosition {
    pub position: (f64, f64, f64),
    pub orientation: ((f64, f64, f64), (f64, f64, f64)),
    pub direction: f64,
}

/// Data specific to units (AI and players).
#[derive(Debug, Serialize, Deserialize, FromArma)]
pub struct UnitData {
    pub loadout: LoadoutWrapper,
    pub medical_state: JsonValue,
}

/// Data specific to players.
#[derive(Debug, Serialize, Deserialize, FromArma)]
pub struct PlayerData {
    pub steam_id: PlayerId,
    pub rank: u8,
}

/// Data specific to vehicles.
#[derive(Debug, Serialize, Deserialize, FromArma)]
pub struct VehicleData {
    pub fuel: f64,
}

/// Enum representing any persistable object.
#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "kind")]
pub enum PersistedObject {
    Unit {
        #[serde(flatten)]
        object: ObjectData,
        #[serde(flatten)]
        unit: UnitData,
    },
    Player {
        #[serde(flatten)]
        object: ObjectData,
        #[serde(flatten)]
        unit: UnitData,
        #[serde(flatten)]
        player: PlayerData,
    },
    Container {
        #[serde(flatten)]
        object: ObjectData,
    },
    Vehicle {
        #[serde(flatten)]
        object: ObjectData,
        #[serde(flatten)]
        vehicle: VehicleData,
    },
    Static {
        #[serde(flatten)]
        object: ObjectData,
    },
}

impl FromArma for PersistedObject {
    fn from_arma(s: String) -> Result<Self, arma_rs::FromArmaError> {
        let json_value: JsonValue =
            serde_json::from_str(&s).map_err(arma_rs::FromArmaError::custom)?;
        serde_json::from_value(json_value).map_err(arma_rs::FromArmaError::custom)
    }
}
