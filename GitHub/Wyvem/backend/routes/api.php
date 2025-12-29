<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\PterodactylCompatibilityController;

Route::prefix('v1')->group(function () {
    Route::get('/pterodactyl/nests', [PterodactylCompatibilityController::class, 'nests']);
    Route::post('/pterodactyl/migrate', [PterodactylCompatibilityController::class, 'migrate']);

    // SSO provider management (CRUD + test)
    use App\Http\Controllers\Api\V1\SsoProviderController;
    Route::get('/sso/providers', [SsoProviderController::class, 'index']);
    Route::post('/sso/providers', [SsoProviderController::class, 'store']);
    Route::get('/sso/providers/{id}', [SsoProviderController::class, 'show']);
    Route::put('/sso/providers/{id}', [SsoProviderController::class, 'update']);
    Route::delete('/sso/providers/{id}', [SsoProviderController::class, 'destroy']);
    Route::post('/sso/providers/{id}/test', [SsoProviderController::class, 'test']);
});
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\PterodactylCompatibilityController;

Route::prefix('v1')->group(function () {
    Route::get('/pterodactyl/nests', [PterodactylCompatibilityController::class, 'nests']);
    Route::post('/pterodactyl/migrate', [PterodactylCompatibilityController::class, 'migrate']);

    // SSO provider management
    use App\Http\Controllers\Api\V1\SsoProviderController;
    Route::get('/sso/providers', [SsoProviderController::class, 'index']);
    Route::post('/sso/providers', [SsoProviderController::class, 'store']);
    Route::post('/sso/providers/{id}/test', [SsoProviderController::class, 'test']);
    Route::get('/sso/providers/{id}', [SsoProviderController::class, 'show']);
    Route::put('/sso/providers/{id}', [SsoProviderController::class, 'update']);
    Route::delete('/sso/providers/{id}', [SsoProviderController::class, 'destroy']);
});
