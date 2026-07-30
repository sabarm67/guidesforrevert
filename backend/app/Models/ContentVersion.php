<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

#[Fillable(['content_type', 'version', 'checksum', 'published_at'])]
class ContentVersion extends Model
{
    protected function casts(): array
    {
        return [
            'published_at' => 'datetime',
        ];
    }
}
