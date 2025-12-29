<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SsoProvider extends Model
{
    protected $table = 'sso_providers';

    protected $fillable = [
        'name', 'type', 'client_id', 'client_secret_encrypted', 'discovery', 'config'
    ];

    protected $casts = [
        'config' => 'array'
    ];

    public function setClientSecretAttribute($value)
    {
        $this->attributes['client_secret_encrypted'] = $value ? encrypt($value) : null;
    }

    public function getClientSecretAttribute()
    {
        return $this->client_secret_encrypted ? decrypt($this->client_secret_encrypted) : null;
    }
}
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SsoProvider extends Model
{
    protected $table = 'sso_providers';

    protected $fillable = [
        'name', 'type', 'client_id', 'client_secret_encrypted', 'discovery', 'config'
    ];

    protected $casts = [
        'config' => 'array'
    ];

    public function setClientSecretAttribute($value)
    {
        $this->attributes['client_secret_encrypted'] = $value ? encrypt($value) : null;
    }

    public function getClientSecretAttribute()
    {
        return $this->client_secret_encrypted ? decrypt($this->client_secret_encrypted) : null;
    }
}
