<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

#[Fillable([
    'faq_key', 'canonical_question', 'question_variants', 'keywords', 'category',
    'answer_text', 'source_citations', 'confidence', 'requires_scholar_disclaimer',
])]
class AiFaqEntry extends Model
{
    protected function casts(): array
    {
        return [
            'question_variants' => 'array',
            'keywords' => 'array',
            'source_citations' => 'array',
            'requires_scholar_disclaimer' => 'boolean',
        ];
    }
}
