# Migration Tool — Using Pterodactyl Official API

This document describes how Wyvem's migration tool will work.
# Migration Tool — Using Pterodactyl Official API

This document describes how Wyvem's migration tool will operate and how to use the provided scaffold.

Overview:
- The migration tool accepts the source Pterodactyl `api_url` and `api_key` and performs a best-effort export/import of entities.
- Entities: Nests, Eggs, Nodes, Users, Servers, and Allocations. Eggs and nest data will be transformed to be compatible with Wyvem.

Using the scaffold frontend:
1. Start the scaffold (see `docs/INSTALL_LINUX.md`).
2. Open the frontend at `http://localhost:8080`.
3. Navigate to "Migration" and provide the source API URL and key.

CLI helper:
- `tools/migrate_from_pterodactyl.sh` demonstrates calling the backend migration endpoint with `curl`.

Security notes:
- Ensure the source API key is handled securely and never stored in logs.
- Prefer to run migrations over secure networks and rotate keys after migration.

Implementation details:
- The backend migration service should fetch paginated resources from the source API, transform them, and insert them into Wyvem's database while recording id mappings.
- Large migrations should be queued and executed as background jobs.
