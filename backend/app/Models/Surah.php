<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'number', 'name_arabic', 'name_english', 'name_transliteration',
    'revelation_type', 'ayah_count', 'beginner_intro',
])]
class Surah extends Model
{
    public function ayahs(): HasMany
    {
        return $this->hasMany(Ayah::class)->orderBy('number_in_surah');
    }
}
