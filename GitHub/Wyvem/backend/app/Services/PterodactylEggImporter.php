<?php

namespace App\Services;

use GuzzleHttp\Client;

class PterodactylEggImporter
{
    protected Client $http;

    public function __construct()
    {
        $this->http = new Client(['timeout' => 15.0]);
    }

    public function importEgg(array $eggPayload): array
    {
        return [
            'status' => 'imported',
            'name' => $eggPayload['name'] ?? 'unnamed',
            'raw' => $eggPayload,
        ];
    }
}
<?php

namespace App\Services;

use GuzzleHttp\Client;

class PterodactylEggImporter
{
    protected Client $http;

    public function __construct()
    {
        $this->http = new Client(['timeout' => 15.0]);
    }

    /**
     * Import an egg payload (array or remote) and transform it for Wyvem.
     */
    public function importEgg(array $eggPayload): array
    {
        // Placeholder: validate and map egg fields to Wyvem's egg schema.
        return [
            'status' => 'imported',
            'name' => $eggPayload['name'] ?? 'unnamed',
            'raw' => $eggPayload,
        ];
    }
}
