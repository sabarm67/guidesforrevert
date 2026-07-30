<?php

namespace Database\Seeders;

use App\Models\Ayah;
use App\Models\AyahTafsir;
use App\Models\AyahTranslation;
use App\Models\AyahWord;
use App\Models\Surah;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class QuranSeeder extends Seeder
{
    public function run(): void
    {
        $seedPath = base_path('content/seed');
        $surahFiles = File::glob("{$seedPath}/quran/*.json");

        foreach ($surahFiles as $file) {
            $surahData = json_decode(File::get($file), true);

            $surah = Surah::updateOrCreate(
                ['number' => $surahData['number']],
                [
                    'name_arabic' => $surahData['name_arabic'],
                    'name_english' => $surahData['name_english'],
                    'name_transliteration' => $surahData['name_transliteration'],
                    'revelation_type' => $surahData['revelation_type'],
                    'ayah_count' => count($surahData['ayahs']),
                    'beginner_intro' => $surahData['beginner_intro'] ?? null,
                ],
            );

            foreach ($surahData['ayahs'] as $ayahData) {
                $ayah = Ayah::updateOrCreate(
                    ['surah_id' => $surah->id, 'number_in_surah' => $ayahData['number_in_surah']],
                    [
                        'juz' => $ayahData['juz'] ?? null,
                        'page' => $ayahData['page'] ?? null,
                        'arabic_text' => $ayahData['arabic_text'],
                    ],
                );

                foreach ($ayahData['translations'] ?? [] as $translation) {
                    AyahTranslation::updateOrCreate(
                        ['ayah_id' => $ayah->id, 'translator' => $translation['translator']],
                        ['text' => $translation['text']],
                    );
                }

                foreach ($ayahData['tafsirs'] ?? [] as $tafsir) {
                    AyahTafsir::updateOrCreate(
                        ['ayah_id' => $ayah->id, 'source' => $tafsir['source']],
                        ['text_summary' => $tafsir['text_summary']],
                    );
                }

                foreach ($ayahData['words'] ?? [] as $word) {
                    AyahWord::updateOrCreate(
                        ['ayah_id' => $ayah->id, 'position' => $word['position']],
                        [
                            'arabic_word' => $word['arabic_word'],
                            'transliteration' => $word['transliteration'],
                            'translation' => $word['translation'],
                        ],
                    );
                }
            }
        }
    }
}
