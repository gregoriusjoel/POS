<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaksi extends Model
{
    protected $fillable = ['user_id', 'total_price'];

    public function details()
    {
        return $this->hasMany(DetailTransaksi::class);
    }
}
