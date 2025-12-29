<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateSsoProviderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'sometimes|string|max:191',
            'type' => 'sometimes|in:oidc,saml,ldap',
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

class UpdateSsoProviderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'sometimes|string|max:191',
            'type' => 'sometimes|in:oidc,saml,ldap',
            'client_id' => 'nullable|string|max:191',
            'client_secret' => 'nullable|string',
            'discovery' => 'nullable|url',
            'config' => 'nullable|array'
        ];
    }
}
