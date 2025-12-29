<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Services\PterodactylMigrationService;

class PterodactylCompatibilityController extends Controller
{
    public function nests(): JsonResponse
    {
        return response()->json([
            'status' => 'ok',
            'data' => [
                ['id' => 1, 'name' => 'Default Nest']
            ]
        ]);
    }

    public function migrate(Request $request, PterodactylMigrationService $migrator): JsonResponse
    {
        $payload = $request->all();
        $result = $migrator->migrateFromPteroApi($payload);

        return response()->json(['status' => 'ok', 'result' => $result]);
    }
}
<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Services\PterodactylMigrationService;

class PterodactylCompatibilityController extends Controller
{
    public function nests(): JsonResponse
    {
        // Placeholder response — real implementation should proxy/translate
        // Pterodactyl's /api/application/nests responses to maintain compatibility.
        return response()->json([
            'status' => 'ok',
            'data' => [
                ['id' => 1, 'name' => 'Default Nest']
            ]
        ]);
    }

    public function migrate(Request $request, PterodactylMigrationService $migrator): JsonResponse
    {
        $payload = $request->all();
        // Validate and queue a migration using the service
        $result = $migrator->migrateFromPteroApi($payload);

        return response()->json(['status' => 'ok', 'result' => $result]);
    }
}
