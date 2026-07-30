<?php

namespace Database\Seeders;

use App\Models\Hadith;
use App\Models\HadithCollection;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class HadithSeeder extends Seeder
{
    public function run(): void
    {
        $seedPath = base_path('../content/seed');
        $files = File::glob("{$seedPath}/hadith/*.json");

        foreach ($files as $file) {
            $data = json_decode(File::get($file), true);

            $collection = HadithCollection::updateOrCreate(
                ['slug' => $data['collection_slug']],
                [
                    'title' => $data['collection_title'],
                    'description' => $data['collection_description'] ?? null,
                ],
            );

            foreach ($data['hadiths'] as $hadithData) {
                Hadith::updateOrCreate(
                    [
                        'hadith_collection_id' => $collection->id,
                        'number_in_collection' => $hadithData['number_in_collection'],
                    ],
                    [
                        'arabic_text' => $hadithData['arabic_text'] ?? null,
                        'english_text' => $hadithData['english_text'],
                        'narrator' => $hadithData['narrator'],
                        'authenticity_grade' => $hadithData['authenticity_grade'],
                        'reference_note' => $hadithData['reference_note'] ?? null,
                        'context' => $hadithData['context'] ?? null,
                        'explanation' => $hadithData['explanation'] ?? null,
                        'practical_application' => $hadithData['practical_application'] ?? null,
                    ],
                );
            }
        }
    }
}
