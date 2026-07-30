<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['surah_id', 'number_in_surah', 'juz', 'page', 'arabic_text'])]
class Ayah extends Model
{
    public function surah(): BelongsTo
    {
        return $this->belongsTo(Surah::class);
    }

    public function translations(): HasMany
    {
        return $this->hasMany(AyahTranslation::class);
    }

    public function tafsirs(): HasMany
    {
        return $this->hasMany(AyahTafsir::class);
    }

    public function words(): HasMany
    {
        return $this->hasMany(AyahWord::class)->orderBy('position');
    }
}
