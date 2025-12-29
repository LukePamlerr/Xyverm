# Wings Integration

Notes about integrating with Pterodactyl Wings.
# Wings Integration

Wyvem integrates with Pterodactyl's `wings` for server orchestration. This doc describes how to configure `wings` to work with Wyvem.

1) Running Wings

Use the provided `docker-compose.yml` service `wings` for development. In production, run `wings` on host nodes with proper systemd service and volumes.

2) Configuration

- Configure `WINGS_TOKEN` and the `wings` config directory. Wyvem will need to present an API endpoint and credentials for `wings` to authenticate.
- Map node identifiers and DAEMON tokens during migration.

3) Security

- Use mTLS or firewall rules between panel and wings nodes.
- Store node secrets encrypted and rotate them periodically.

4) Migrating nodes

- During migration, fetch node configs from the source Pterodactyl and re-provision them in Wyvem, creating new tokens for each node.
