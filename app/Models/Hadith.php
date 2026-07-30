<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'hadith_collection_id', 'number_in_collection', 'arabic_text', 'english_text',
    'narrator', 'authenticity_grade', 'reference_note', 'context', 'explanation',
    'practical_application',
])]
class Hadith extends Model
{
    public function collection(): BelongsTo
    {
        return $this->belongsTo(HadithCollection::class, 'hadith_collection_id');
    }
}
