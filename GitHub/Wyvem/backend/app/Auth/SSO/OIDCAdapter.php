<?php

namespace App\Auth\SSO;

use League\OAuth2\Client\Provider\GenericProvider;

class OIDCAdapter implements AdapterInterface
{
    protected GenericProvider $provider;

    public function __construct(array $config = [])
    {
        $this->provider = new GenericProvider([
            'clientId' => $config['client_id'] ?? '',
            'clientSecret' => $config['client_secret'] ?? '',
            'redirectUri' => $config['redirect_uri'] ?? '',
            'urlAuthorize' => $config['authorize_url'] ?? '',
            'urlAccessToken' => $config['token_url'] ?? '',
            'urlResourceOwnerDetails' => $config['userinfo_url'] ?? '',
        ]);
    }

    public function redirectUrl(array $options = []): string
    {
        return $this->provider->getAuthorizationUrl($options);
    }

    public function handleCallback(array $request): array
    {
        return ['sub' => 'user@example.com'];
    }
}
<?php

namespace App\Auth\SSO;

use League\OAuth2\Client\Provider\GenericProvider;

class OIDCAdapter implements AdapterInterface
{
    protected GenericProvider $provider;

    public function __construct(array $config = [])
    {
        $this->provider = new GenericProvider([
            'clientId' => $config['client_id'] ?? '',
            'clientSecret' => $config['client_secret'] ?? '',
            'redirectUri' => $config['redirect_uri'] ?? '',
            'urlAuthorize' => $config['authorize_url'] ?? '',
            'urlAccessToken' => $config['token_url'] ?? '',
            'urlResourceOwnerDetails' => $config['userinfo_url'] ?? '',
        ]);
    }

    public function redirectUrl(array $options = []): string
    {
        return $this->provider->getAuthorizationUrl($options);
    }

    public function handleCallback(array $request): array
    {
        // Placeholder: exchange code for token and fetch user info
        return ['sub' => 'user@example.com'];
    }
}
