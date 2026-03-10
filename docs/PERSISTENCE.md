# Persistence

Persistence is based on two scopes:
- Global Player Info
- Campaign Data

## Global Info

Information about the physical player. This lives forever.

A player's global info is:
- Their SteamID64 as a unique identifier;
- Their last seen name;
- Their certifications;
- Whether they are an admin;
- Whether they are banned;
- When they first joined;
- The last time they joined.

Global meta-information is:
- A list of certifications.

Global meta-information to be expanded with the introduction of the shop and garage systems.

## Campaign Data

Persisted data throughout a campaign. This lives for as long as the campaign does.

Campaign data may include both more specific player data as well as objects and other information. All aspects of campaign data may or may not be persisted.

A player's campaign data is:
- Their position on any number of terrains within that campaign.
- Their medical state within that campaign.
- Their loadout within that campaign.

A campaign's meta information is:
- Its unique ID;
- Its name;
- Its description;
- Whether positions are persisted;
- Whether medical state is persisted;
- Whether loadouts are persisted;
- Whether it uses the (unimplemented) shop system;
- Whether it persists other world data (vehicles, static objects).

# Loading player data

Loading player data follows this pattern:
1. Load global information.
2. Load campaign data.

# Saving player data

Saves are triggered:
- Periodically (auto-save interval)
- On player disconnect (including crashes, kicks, and voluntary disconnects)
- On significant state changes (configurable)

Player data is saved directly to campaign storage when persistence is enabled for the campaign.

# Database Schema

The persistence system uses PostgreSQL with two main schema namespaces:
- `skua_master` - Global data (players, campaigns)
- `skua_campaign_{id}` - Per-campaign data (dynamically created)

## Master Schema (`skua_master`)

### `player_info`
Stores global player information that persists forever.

| Column | Type | Description |
|--------|------|-------------|
| `steam_id` | `BIGINT` | Primary key. SteamID64 unique identifier |
| `name` | `TEXT` | Player's last seen name |
| `first_seen` | `TIMESTAMPTZ` | When the player first joined (auto-set) |
| `last_seen` | `TIMESTAMPTZ` | When the player was last seen (auto-set) |
| `is_admin` | `BOOLEAN` | Whether the player is an admin (default: false) |
| `is_banned` | `BOOLEAN` | Whether the player is banned (default: false) |
| `rank` | `SMALLINT` | Player's rank (foreign key to `ranks.id`) |

**Indexes:**
- `idx_player_info_is_admin` - For finding all admins
- `idx_player_info_is_banned` - For finding all banned players

### `certifications`
Stores the list of available certifications.

| Column | Type | Description |
|--------|------|-------------|
| `uuid` | `UUID` | Primary key. Unique identifier for the certification |
| `display_name` | `TEXT` | Human-readable certification name (unique) |

### `player_certs`
Junction table linking players to their certifications.

| Column | Type | Description |
|--------|------|-------------|
| `steam_id` | `BIGINT` | Foreign key to `player_info.steam_id` |
| `cert_uuid` | `UUID` | Foreign key to `certifications.uuid` |

**Composite Primary Key:** `(steam_id, cert_uuid)`

**Indexes:**
- `idx_player_certs_steam_id` - For finding all certs a player has
- `idx_player_certs_cert_uuid` - For finding all players with a given cert

### `ranks`
Stores the list of available ranks.

| Column | Type | Description |
|--------|------|-------------|
| `id` | `SMALLINT` | Primary key. Numeric rank identifier |
| `display_name` | `TEXT` | Human-readable rank name (unique) |

### `campaigns`
Stores campaign metadata.

| Column | Type | Description |
|--------|------|-------------|
| `campaign_id` | `TEXT` | Primary key. Arbitrary campaign identifier |
| `name` | `TEXT` | Campaign name |
| `description` | `TEXT` | Campaign description (optional) |
| `persist_position` | `BOOLEAN` | Whether player positions are persisted (default: false) |
| `persist_medical` | `BOOLEAN` | Whether medical state is persisted (default: false) |
| `persist_loadout` | `BOOLEAN` | Whether loadouts are persisted (default: false) |
| `using_shop` | `BOOLEAN` | Whether the shop system is enabled (default: false) |
| `persisting_world_data` | `BOOLEAN` | Whether world objects are persisted (default: false) |

## Campaign Schema (`skua_campaign_${UUID}`)

Campaign schemas are created dynamically per campaign using the campaign's UUID. Each contains:

### `player_data`
Stores persistent player data for a campaign (world-agnostic).

| Column | Type | Description |
|--------|------|-------------|
| `steam_id` | `BIGINT` | Primary key. Foreign key to `skua_master.player_info.steam_id` |
| `loadout` | `TEXT` | Serialized Arma loadout array |
| `medical_data` | `JSONB` | Medical state (ACE Medical) |
| `last_updated` | `TIMESTAMPTZ` | When this record was last updated (used for conflict resolution) |

This stores data that applies across all worlds in the campaign (loadout, medical state).

### `player_world_data`
Stores player's positions for a campaign across multiple worlds/terrains.

| Column | Type | Description |
|--------|------|-------------|
| `steam_id` | `BIGINT` | Foreign key to `skua_master.player_info.steam_id` |
| `world` | `TEXT` | Terrain/map name where this position is relevant |
| `position` | `TEXT` | Serialized position coordinates |
| `last_updated` | `TIMESTAMPTZ` | When this record was last updated (used for conflict resolution) |

**Composite Primary Key:** `(steam_id, world)`

This allows players to have different positions on different terrains within the same campaign.

### `world_data`
Stores persistent world objects (vehicles, static objects) for a campaign.

| Column | Type | Description |
|--------|------|-------------|
| `uuid` | `UUID` | Unique identifier for the object |
| `world` | `TEXT` | Terrain/map name where the object exists |
| `classname` | `TEXT` | Arma classname of the object |
| `position` | `TEXT` | Serialized position coordinates |

**Composite Primary Key:** `(uuid, world)`