# SSO Implementation Details

Adapter pattern and security notes.
# SSO Implementation Details

This document outlines the approach for Wyvem's advanced SSO system.

Design:
- Use an adapter pattern (`app/Auth/SSO/*Adapter.php`) for each protocol.
- Support OIDC (recommended), SAML, LDAP, and OAuth2 connectors.
- Provide admin UI to configure providers with metadata, client IDs/secrets, scopes, and claim mappings.
- Support account linking flows and automatic user provisioning.
- Store provider configs encrypted in the database and allow test connections.

Security:
- Use PKCE for public clients and rotate secrets regularly.
- Do not persist third-party access tokens unless required; store refresh tokens encrypted if needed.
- Log only non-sensitive events and avoid storing raw ID tokens in logs.

Operations:
- Provide endpoints to import IdP metadata (SAML) and well-known OIDC configuration.
- Expose a `/.well-known/wyvem-ssoconfig` for discovery by admin tooling.
