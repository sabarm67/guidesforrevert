<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['user_id', 'entry_date', 'mood', 'prayer_checklist', 'reflection_text'])]
class JournalEntry extends Model
{
    protected function casts(): array
    {
        return [
            'entry_date' => 'date',
            'prayer_checklist' => 'array',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
