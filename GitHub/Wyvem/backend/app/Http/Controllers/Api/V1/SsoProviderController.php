<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreSsoProviderRequest;
use App\Models\SsoProvider;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class SsoProviderController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['data' => SsoProvider::all()]);
    }

    public function store(StoreSsoProviderRequest $request): JsonResponse
    {
        $data = $request->only(['name', 'type', 'client_id', 'discovery', 'config']);
        $provider = new SsoProvider($data);
        if ($request->filled('client_secret')) {
            $provider->client_secret = $request->input('client_secret');
        }
        $provider->save();
        return response()->json(['data' => $provider], 201);
    }

    public function show($id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);
        return response()->json(['data' => $provider]);
    }

    public function update(\App\Http\Requests\UpdateSsoProviderRequest $request, $id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);
        $data = $request->only(['name', 'type', 'client_id', 'discovery', 'config']);
        $provider->fill($data);
        if ($request->filled('client_secret')) {
            $provider->client_secret = $request->input('client_secret');
        }
        $provider->save();
        return response()->json(['data' => $provider]);
    }

    public function destroy($id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);
        $provider->delete();
        return response()->json(['ok' => true]);
    }

    public function test(Request $request, $id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);

        if ($provider->type === 'oidc' && $provider->discovery) {
            try {
                $resp = Http::get($provider->discovery);
                return response()->json(['ok' => true, 'discovery' => $resp->json()]);
            } catch (\Exception $e) {
                return response()->json(['ok' => false, 'error' => $e->getMessage()], 400);
            }
        }

        return response()->json(['ok' => true, 'message' => 'Test handler placeholder for type ' . $provider->type]);
    }
}
<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreSsoProviderRequest;
use App\Models\SsoProvider;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class SsoProviderController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(['data' => SsoProvider::all()]);
    }

    public function store(StoreSsoProviderRequest $request): JsonResponse
    {
        $data = $request->only(['name', 'type', 'client_id', 'discovery', 'config']);
        $provider = new SsoProvider($data);
        if ($request->filled('client_secret')) {
            $provider->client_secret = $request->input('client_secret');
        }
        $provider->save();
        return response()->json(['data' => $provider], 201);
    }

    public function show($id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);
        return response()->json(['data' => $provider]);
    }

    public function update(\App\Http\Requests\UpdateSsoProviderRequest $request, $id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);
        $data = $request->only(['name', 'type', 'client_id', 'discovery', 'config']);
        $provider->fill($data);
        if ($request->filled('client_secret')) {
            $provider->client_secret = $request->input('client_secret');
        }
        $provider->save();
        return response()->json(['data' => $provider]);
    }

    public function destroy($id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);
        $provider->delete();
        return response()->json(['ok' => true]);
    }

    public function test(Request $request, $id): JsonResponse
    {
        $provider = SsoProvider::findOrFail($id);

        if ($provider->type === 'oidc' && $provider->discovery) {
            try {
                $resp = Http::get($provider->discovery);
                return response()->json(['ok' => true, 'discovery' => $resp->json()]);
            } catch (\Exception $e) {
                return response()->json(['ok' => false, 'error' => $e->getMessage()], 400);
            }
        }

        // SAML/LDAP basic placeholder
        return response()->json(['ok' => true, 'message' => 'Test handler placeholder for type ' . $provider->type]);
    }
}
