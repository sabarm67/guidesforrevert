<?php

namespace Database\Seeders;

use App\Models\AiFaqEntry;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class AiFaqSeeder extends Seeder
{
    public function run(): void
    {
        $seedPath = base_path('content/seed');
        $entries = json_decode(File::get("{$seedPath}/ai-mentor-faq.json"), true);

        foreach ($entries as $entry) {
            AiFaqEntry::updateOrCreate(
                ['faq_key' => $entry['id']],
                [
                    'canonical_question' => $entry['canonical_question'],
                    'question_variants' => $entry['question_variants'],
                    'keywords' => $entry['keywords'],
                    'category' => $entry['category'],
                    'answer_text' => $entry['answer_text'],
                    'source_citations' => $entry['source_citations'],
                    'confidence' => $entry['confidence'],
                    'requires_scholar_disclaimer' => $entry['requires_scholar_disclaimer'],
                ],
            );
        }
    }
}
