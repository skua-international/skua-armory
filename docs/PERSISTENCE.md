# Persistence

Persistence is based on three scopes:
- Global Player Info
- Campaign Data
- Session Data

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

## Session Data

Persisted through a session. Session data (also called ephemeral data) has an expiration date: a certain amount of time after its creation, or until the next mission change, whichever comes first. Session data only persists player data, and is a mirror of the campaign data.

All aspects of session data are always saved.

A player's session is:
- Their position;
- Their medical state;
- Their loadout;
- The expiration data for the session data.

A session's meta information is:
- Its unique ID;
- The world (terrain) being used;
- Optionally, a campaign ID indicating what campaign it is a part of;
- Whether it is active, that is, if it is still running;
- The last time the server pinged for this session;
- The expiration date for the session itself;

# Loading player data

Loading player data follows this pattern:
1. Load global information.
2. If they have unexpired & active session data, load it.
3. If they do not have session data, load their campaign data.

## Why load session data before campaign data

Loading session data first prevents several classes of exploits where players disconnect to gain an advantage.

### Combat Logging
If a player disconnects during combat, their session data preserves their exact state at disconnect. When they rejoin, they resume with the same position, medical state, and loadout - not the potentially safer state saved in campaign data from an earlier mission. This prevents escaping combat consequences by logging out.

### Position Exploits (Teleporting)
Without session data priority, a player could:
1. Save their campaign position at a safe location (e.g., base)
2. Travel to a dangerous area during the mission
3. Disconnect to reload the safe campaign position
4. Effectively "teleport" back to base

Session data prevents this by ensuring the disconnect position is what gets loaded, not the stale campaign position.

### Medical State Exploits
A player injured during the mission cannot heal by disconnecting and reconnecting, as their current injured state is preserved in session data. Without this, players could restore themselves to the healthy state saved in campaign data.

### Loadout Exploits
Players cannot change their loadout by disconnecting. The session preserves their current loadout, preventing:
- Swapping to better gear mid-mission by reloading campaign loadout
- Bypassing loadout restrictions or changes made during the mission
- Exploiting inventory states that differ from campaign saves

### Session Expiration
Session data expires after a configurable time or when the mission ends, at which point campaign data becomes the authoritative source again. This ensures that legitimate mission changes (like moving to a new operation area) properly persist between missions while preventing within-mission exploits.

The campaign data acts as a long-term checkpoint system between missions, while session data acts as a short-term anti-exploit mechanism within missions.

# Saving player data

Saving player data follows this pattern:
1. Always save to session data (ephemeral).
2. If the session is part of a campaign and campaign persistence is enabled, automatically promote the data to campaign storage via database triggers.

Saves are triggered:
- Periodically (auto-save interval)
- On player disconnect (including crashes, kicks, and voluntary disconnects)
- On significant state changes (configurable)

This dual-save approach ensures:
- Session data always has the most recent state for anti-exploit purposes
- Campaign data is kept in sync for long-term persistence
- The promotion happens automatically and atomically at the database level
- No duplicate save logic needed in application code
- Disconnect-based exploits are prevented by saving on disconnect

## Promotion Trigger

When session player data is inserted or updated, if a `campaign_id` is present, the database automatically copies the data to the corresponding campaign table. This ensures campaign progress is preserved even if the session expires or the server crashes before explicit campaign saves can occur. There can be concurrent sessions, even running the same map, within a campaign. This can particularly be the case for the training server and default ops or Liberation, which all run on the default campaign.

### Timestamp-Based Conflict Resolution

To prevent stale session data from overwriting newer campaign data (e.g., when a player rejoins an old session after playing on a different server), promotion uses timestamp comparison:

- Each session save includes a `saved_at` timestamp
- Campaign tables track `last_updated` timestamp
- Promotion only succeeds if `saved_at >= last_updated`
- If the campaign was updated more recently by another session, the promotion is silently skipped

This prevents cross-session exploits where a player could:
1. Save on Session A (healthy state)
2. Join Session B, take damage, save (injured state promoted to campaign)
3. Rejoin Session A (loads old healthy session data)
4. Save on Session A → **blocked** because campaign `last_updated` is newer

### Stale Data Visibility

When a player rejoins an old session after another session has updated the campaign, they may temporarily see stale data (their old session state) until the next save attempt. This is acceptable behavior - the stale data cannot be promoted to campaign, and the player will receive current campaign data on their next full load (e.g., after session expiry or mission change).

# Database Schema

The persistence system uses PostgreSQL with three main schema namespaces:
- `skua_master` - Global data (players, campaigns, sessions)
- `skua_campaign_{uuid}` - Per-campaign data (dynamically created)
- `skua_session_{uuid}` - Per-session ephemeral data (dynamically created)

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

### `sessions`
Stores session metadata for active and recent sessions.

| Column | Type | Description |
|--------|------|-------------|
| `session_id` | `UUID` | Session unique identifier |
| `world` | `TEXT` | Terrain/map name |
| `campaign_id` | `TEXT` | Associated campaign (optional, may be NULL) |
| `is_active` | `BOOLEAN` | Whether the session is currently running (default: true) |
| `heartbeat` | `TIMESTAMPTZ` | Last server ping time (auto-updated) |
| `deadline` | `TIMESTAMPTZ` | Session expiration time (auto-updated to heartbeat + 10 minutes) |

**Composite Primary Key:** `(session_id, world)`

**Indexes:**
- `idx_sessions_is_active` - For finding active sessions

**Triggers:**
- `trg_update_session_heartbeat` - Automatically updates `heartbeat` and `deadline` on any update

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

Session medical state and loadout take precedence over the campaign's.

### `player_world_data`
Stores player's positions for a campaign across multiple worlds/terrains.

| Column | Type | Description |
|--------|------|-------------|
| `steam_id` | `BIGINT` | Foreign key to `skua_master.player_info.steam_id` |
| `world` | `TEXT` | Terrain/map name where this position is relevant |
| `position` | `TEXT` | Serialized position coordinates |
| `last_updated` | `TIMESTAMPTZ` | When this record was last updated (used for conflict resolution) |

**Composite Primary Key:** `(steam_id, world)`

This allows players to have different positions on different terrains within the same campaign. Session position takes precedence over campaign position.

### `world_data`
Stores persistent world objects (vehicles, static objects) for a campaign.

| Column | Type | Description |
|--------|------|-------------|
| `uuid` | `UUID` | Unique identifier for the object |
| `world` | `TEXT` | Terrain/map name where the object exists |
| `classname` | `TEXT` | Arma classname of the object |
| `position` | `TEXT` | Serialized position coordinates |

**Composite Primary Key:** `(uuid, world)`

## Session Schema (`skua_session_{uuid}`)

Session schemas are created dynamically per session using the session's UUID. Each contains:

### `player_data`
Stores ephemeral player data for reconnects during a session.

| Column | Type | Description |
|--------|------|-------------|
| `steam_id` | `BIGINT` | Primary key. Foreign key to `skua_master.player_info.steam_id` |
| `world` | `TEXT` | Terrain/map name (used by promotion trigger) |
| `campaign_id` | `TEXT` | Associated campaign UUID (optional, triggers promotion) |
| `loadout` | `TEXT` | Serialized Arma loadout array |
| `position` | `TEXT` | Serialized position coordinates |
| `medical_data` | `JSONB` | Medical state (ACE Medical) |
| `saved_at` | `TIMESTAMPTZ` | When this record was saved (used for conflict resolution during promotion) |
| `deadline` | `TIMESTAMPTZ` | When this player's data expires |

**Triggers:**
- `trg_ephemeral_player_data_promote` - Automatically copies data to campaign schema if `campaign_id` is set, using timestamp comparison to prevent stale data from overwriting newer campaign data

## Database Functions

### `promote_ephemeral_player_data`
```sql
promote_ephemeral_player_data(
    campaign_id TEXT,
    world TEXT,
    steam_id BIGINT,
    loadout TEXT,
    position TEXT,
    medical_data JSONB,
    saved_at TIMESTAMPTZ
)
```

Automatically invoked by the trigger on ephemeral `player_data` inserts/updates. If `campaign_id` is not NULL, promotes the data to the corresponding campaign's tables using timestamp-based conflict resolution:

- `player_data` - Updates loadout and medical_data only if `saved_at >= last_updated`
- `player_world_data` - Updates position for the specific world only if `saved_at >= last_updated`

The timestamp comparison prevents stale session data from overwriting newer campaign data that was promoted by a different session. This protects against cross-session exploits in campaigns with concurrent sessions.

### `update_heartbeat`
Automatically invoked by the trigger on `sessions` updates. Updates the `heartbeat` to current time and extends the `deadline` by 10 minutes.