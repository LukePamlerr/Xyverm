Wyvem — Pterodactyl-compatible Panel Fork (Scaffold)

This repository contains a scaffold for a Pterodactyl-compatible control panel fork.

Contents:
- `backend/` — Laravel-compatible backend stubs and services
- `frontend/` — Vue 3 admin UI scaffold
- `docs/` — installation and design docs
- `docker/` — nginx config for development
- `scripts/` & `tools/` — helper scripts

This is a work-in-progress scaffold. Follow docs/INSTALL_LINUX.md to run locally via Docker.
Wyvem — Pterodactyl-compatible Panel Fork (Scaffold)

Wyvem is a starter scaffold for a Pterodactyl-compatible control panel fork. This repository contains an initial project layout, deployment compose, docs, and helper scripts to begin development.

This scaffold is NOT a finished panel. It provides:
- A Docker Compose sample for local development.
- Installation guides for common Linux distributions.
- Stubs for a Laravel backend and Vue frontend.
- Documentation and an SSO feature plan.

See docs/INSTALL_LINUX.md for quick Linux setup instructions.

Next steps:
- Implement the Laravel backend with full Pterodactyl API compatibility.
- Implement the Vue admin UI and user-facing pages.
- Add advanced SSO providers (OIDC, SAML, LDAP, OAuth2).
