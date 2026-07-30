<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'dua_category_id', 'title', 'arabic_text', 'transliteration', 'translation',
    'reference', 'authenticity', 'benefits', 'audio_url', 'is_daily_featured', 'order',
])]
class Dua extends Model
{
    protected function casts(): array
    {
        return [
            'is_daily_featured' => 'boolean',
        ];
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(DuaCategory::class, 'dua_category_id');
    }
}
