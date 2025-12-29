<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreSsoProviderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:191',
            'type' => 'required|in:oidc,saml,ldap',
            'client_id' => 'nullable|string|max:191',
            'client_secret' => 'nullable|string',
            'discovery' => 'nullable|url',
            'config' => 'nullable|array'
        ];
    }
}
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreSsoProviderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'required|string|max:191',
            'type' => 'required|in:oidc,saml,ldap',
            'client_id' => 'nullable|string|max:191',
            'client_secret' => 'nullable|string',
            'discovery' => 'nullable|url',
            'config' => 'nullable|array'
        ];
    }
}
