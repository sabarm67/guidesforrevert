<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['ayah_id', 'source', 'text_summary'])]
class AyahTafsir extends Model
{
    public function ayah(): BelongsTo
    {
        return $this->belongsTo(Ayah::class);
    }
}
