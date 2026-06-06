<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes, \App\Traits\BelongsToTenant;

    protected $fillable = ['tenant_id', 'item_name', 'item_code', 'price'];

    public function tenant()
    {
        return $this->belongsTo(Tenant::class);
    }
}
