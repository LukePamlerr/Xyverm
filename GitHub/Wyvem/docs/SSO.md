# SSO Plan (Advanced)

Planned SSO support: OIDC, SAML, LDAP, OAuth2, TOTP.
# SSO Plan (Advanced)

Wyvem will support a multi-provider Single Sign-On (SSO) system with the following planned features:

- OIDC (OpenID Connect) provider and client flows (Authorization Code + PKCE).
- SAML 2.0 Service Provider integration.
- OAuth2 provider/client support for third-party logins.
- LDAP authentication (with optional user sync and group mapping).
- Multi-factor authentication (TOTP) and adaptive policies.
- Role and permission mapping between external identity sources and Wyvem roles.
- IdP metadata import/export and discovery.

Implementation notes:
- Use a modular auth bridge with adapters for each protocol.
- Provide an admin UI to configure providers and mappings.
- Ensure account linking, prova of possession, and secure token storage.
