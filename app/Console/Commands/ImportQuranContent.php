<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

/**
 * Pulls verified Quran text from the official quran.com API (api.quran.com)
 * and writes content/seed/quran/*.json in this project's seed schema.
 *
 * Arabic text (text_uthmani) mirrors the Tanzil Project's Uthmani text,
 * which is freely redistributable with attribution (see content/seed/SOURCES.md).
 * The default translation is Pickthall (translation_id 19) — a
 * public-domain (pre-1964, non-renewed US copyright) English translation,
 * chosen specifically to avoid the licensing risk of modern translations
 * like Saheeh International, which are not freely redistributable.
 *
 * This is a content-authoring tool run locally to produce static seed
 * files — the shipped app never calls this API at runtime.
 */
class ImportQuranContent extends Command
{
    protected $signature = 'quran:import
        {surahs* : Chapter numbers to import (e.g. 78 79 80)}
        {--translation=19 : quran.com translation resource id (19=Pickthall, 22=Yusuf Ali, 20=Saheeh International)}
        {--translator-name=Pickthall : Label stored in the translations array}';

    protected $description = 'Import Quran surahs from the official quran.com API into content/seed/quran/*.json';

    public function handle(): int
    {
        $translationId = (string) $this->option('translation');
        $translatorName = $this->option('translator-name');
        $outputDir = base_path('content/seed/quran');

        foreach ($this->argument('surahs') as $number) {
            $number = (int) $number;
            $this->info("Fetching surah {$number}...");

            $chapter = Http::get("https://api.quran.com/api/v4/chapters/{$number}", ['language' => 'en'])
                ->throw()->json('chapter');

            $verses = Http::get("https://api.quran.com/api/v4/verses/by_chapter/{$number}", [
                'translations' => $translationId,
                'fields' => 'text_uthmani',
                'per_page' => 300,
            ])->throw()->json('verses');

            $ayahs = array_map(function (array $verse) use ($translatorName) {
                $text = $verse['translations'][0]['text'] ?? '';
                $text = trim(html_entity_decode(strip_tags($text)));

                return [
                    'number_in_surah' => $verse['verse_number'],
                    'juz' => $verse['juz_number'],
                    'page' => $verse['page_number'],
                    'arabic_text' => trim($verse['text_uthmani']),
                    'translations' => [
                        ['translator' => $translatorName, 'text' => $text],
                    ],
                ];
            }, $verses);

            $slug = Str::slug($chapter['name_simple']);
            $paddedNumber = str_pad((string) $number, 3, '0', STR_PAD_LEFT);
            $revelationType = $chapter['revelation_place'] === 'makkah' ? 'meccan' : 'medinan';

            $surahData = [
                'number' => $chapter['id'],
                'name_arabic' => $chapter['name_arabic'],
                'name_english' => $chapter['translated_name']['name'],
                'name_transliteration' => $chapter['name_simple'],
                'revelation_type' => $revelationType,
                'beginner_intro' => sprintf(
                    '%s ("%s") is a %s surah of %d ayahs. Arabic text: Tanzil Project (Uthmani script). Translation: %s (public domain).',
                    $chapter['name_simple'],
                    $chapter['translated_name']['name'],
                    $revelationType === 'meccan' ? 'Meccan' : 'Medinan',
                    $chapter['verses_count'],
                    $translatorName,
                ),
                'ayahs' => $ayahs,
            ];

            $path = "{$outputDir}/surah-{$paddedNumber}-{$slug}.json";
            File::put($path, json_encode($surahData, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)."\n");
            $this->info("Wrote {$path}");
        }

        return self::SUCCESS;
    }
}
