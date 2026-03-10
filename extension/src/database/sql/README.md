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
- `100-199`: Campaign schema templates
  - `100`: Schema creation
  - `110-119`: Player data table
  - `120-129`: Player world data table and indexes
  - `130-139`: World data table and indexes

## Execution Order

Files should be executed in numeric order. Higher layer numbers depend on lower layer numbers.

## Template Variables

Campaign schema files use template variables that must be replaced before execution:

- `${campaign_id}` - Campaign identifier with hyphens replaced by underscores (arbitrary TEXT)

Example:
```
Campaign ID: my-campaign-name
Schema: skua_campaign_my_campaign_name
```

## Dynamic Schema Creation

Campaign schemas are created dynamically at runtime. The application should:

1. Use an arbitrary identifier for the campaign
2. Replace the template variable in the SQL
3. Execute the schema creation SQL

## Postgres Features Used

- `EXECUTE format()` for dynamic SQL
- Partial indexes with `WHERE` clauses
- `JSONB` for flexible medical data storage
