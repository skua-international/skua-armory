# SQL Schema Files

These files define the database schema for the persistence system.

## File Naming Convention

Files use 3-digit numbering to allow for insertion of new files between existing ones.
Each SQL file contains exactly ONE statement (PostgreSQL prepared statements don't support multiple commands).

- `000-099`: Master schema (global data)
  - `000`: Schema creation
  - `010-019`: Independent base tables (ranks, certifications, campaigns)
  - `020-029`: Player info table and indexes
  - `030-039`: Player certs table and indexes
  - `040-049`: Sessions table and indexes
  - `050-059`: Master functions and triggers
- `100-199`: Campaign schema templates
  - `100`: Schema creation
  - `110-119`: Player data table
  - `120-129`: Player world data table and indexes
  - `130-139`: World data table and indexes
- `200-299`: Session schema templates
  - `200`: Schema creation
  - `210-219`: Player data table and indexes
  - `220-229`: Promotion function and trigger

## Execution Order

Files should be executed in numeric order. Higher layer numbers depend on lower layer numbers.

## Template Variables

Campaign and session schema files use template variables that must be replaced before execution:

- `${campaign_id}` - Campaign identifier with hyphens replaced by underscores (arbitrary TEXT)
- `${session_id}` - Session UUID with hyphens replaced by underscores

Examples:
```
Campaign ID: my-campaign-name
Schema: skua_campaign_my_campaign_name

Session UUID: 550e8400-e29b-41d4-a716-446655440000
Schema: skua_session_550e8400_e29b_41d4_a716_446655440000
```

## Dynamic Schema Creation

Campaign and session schemas are created dynamically at runtime. The application should:

1. Generate a new UUID for sessions or use an arbitrary identifier for campaigns
2. Replace the template variable in the SQL
3. Execute the schema creation SQL

## Postgres 18 Features Used

- Standard `CREATE OR REPLACE TRIGGER` syntax
- `EXECUTE format()` for dynamic SQL
- Partial indexes with `WHERE` clauses
- `JSONB` for flexible medical data storage

## Timestamp-Based Conflict Resolution

The promotion trigger uses `saved_at` (session) vs `last_updated` (campaign) timestamps to prevent stale session data from overwriting newer campaign data. This protects against cross-session exploits where a player could rejoin an old session to roll back consequences from a different session.
