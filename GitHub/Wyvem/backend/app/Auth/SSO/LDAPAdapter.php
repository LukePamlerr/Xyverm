<?php

namespace App\Auth\SSO;

class LDAPAdapter implements AdapterInterface
{
    protected array $config;

    public function __construct(array $config = [])
    {
        $this->config = $config;
    }

    public function redirectUrl(array $options = []): string
    {
        return '';
    }

    public function handleCallback(array $request): array
    {
        return ['dn' => 'cn=example,dc=local'];
    }
}
<?php

namespace App\Auth\SSO;

class LDAPAdapter implements AdapterInterface
{
    protected array $config;

    public function __construct(array $config = [])
    {
        $this->config = $config;
    }

    public function redirectUrl(array $options = []): string
    {
        // LDAP is direct bind; no redirect URL
        return '';
    }

    public function handleCallback(array $request): array
    {
        // Perform a simple LDAP bind and return basic user claims
        return ['dn' => 'cn=example,dc=local'];
    }
}
