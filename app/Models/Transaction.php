<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use \App\Traits\BelongsToTenant;

    protected $fillable = ['tenant_id', 'user_id', 'total_amount', 'customer_name', 'trans_date', 'number'];

    protected $casts = [
        'total_amount' => 'decimal:2',
        'trans_date' => 'datetime',
    ];

    public function tenant()
    {
        return $this->belongsTo(Tenant::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function items()
    {
        return $this->hasMany(TransactionItem::class);
    }
}
