<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['slug', 'title', 'description'])]
class HadithCollection extends Model
{
    public function hadiths(): HasMany
    {
        return $this->hasMany(Hadith::class)->orderBy('number_in_collection');
    }
}
