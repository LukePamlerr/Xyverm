<?php

namespace App\Services;

use GuzzleHttp\Client;

class PterodactylMigrationService
{
    protected Client $http;

    public function __construct()
    {
        $this->http = new Client(['timeout' => 10.0]);
    }

    public function migrateFromPteroApi(array $payload): array
    {
        return ['message' => 'migration queued', 'payload' => $payload];
    }
}
<?php

namespace App\Services;

use GuzzleHttp\Client;

class PterodactylMigrationService
{
    protected Client $http;

    public function __construct()
    {
        $this->http = new Client(['timeout' => 10.0]);
    }

    /**
     * Migrate data from an existing Pterodactyl installation using its API.
     * Payload should contain `api_url` and `api_key` for the source.
     */
    public function migrateFromPteroApi(array $payload): array
    {
        // This is a placeholder implementation. A production implementation
        // should perform authenticated requests to the source pterodactyl API,
        // transform entities (nodes, nests, eggs, users, servers) and insert
        // them into Wyvem's database, keeping mappings and IDs compatible.

        // Example outline:
        // 1. GET /api/application/nests from source
        // 2. For each nest, GET eggs and transform
        // 3. Create local records and map ids

        return ['message' => 'migration queued', 'payload' => $payload];
    }
}
