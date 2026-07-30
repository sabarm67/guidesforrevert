<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

#[Fillable([
    'name', 'type', 'latitude', 'longitude', 'address', 'phone',
    'website', 'osm_id', 'verified',
])]
class CommunityPlace extends Model
{
    protected function casts(): array
    {
        return [
            'latitude' => 'decimal:7',
            'longitude' => 'decimal:7',
            'verified' => 'boolean',
        ];
    }
}
