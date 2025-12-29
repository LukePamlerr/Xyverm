<?php

namespace App\Auth\SSO;

interface AdapterInterface
{
    public function redirectUrl(array $options = []): string;
    public function handleCallback(array $request): array;
}
<?php

namespace App\Auth\SSO;

interface AdapterInterface
{
    /**
     * Redirect the user to the identity provider for authentication.
     */
    public function redirectUrl(array $options = []): string;

    /**
     * Handle the callback from the identity provider and return user claims.
     */
    public function handleCallback(array $request): array;
}
