<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['slug', 'title', 'icon', 'order'])]
class DuaCategory extends Model
{
    public function duas(): HasMany
    {
        return $this->hasMany(Dua::class)->orderBy('order');
    }
}
