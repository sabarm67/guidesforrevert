<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable([
    'learning_stage_id', 'slug', 'order', 'title', 'summary', 'body',
    'estimated_minutes', 'need_to_know', 'is_published', 'version',
])]
class Lesson extends Model
{
    protected function casts(): array
    {
        return [
            'body' => 'array',
            'need_to_know' => 'boolean',
            'is_published' => 'boolean',
        ];
    }

    public function learningStage(): BelongsTo
    {
        return $this->belongsTo(LearningStage::class);
    }

    public function progress(): HasMany
    {
        return $this->hasMany(LessonProgress::class);
    }

    public function quizzes(): HasMany
    {
        return $this->hasMany(Quiz::class);
    }
}
