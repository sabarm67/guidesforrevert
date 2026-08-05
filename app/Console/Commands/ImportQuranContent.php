<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

/**
 * Pulls Quran text and writes content/seed/quran/*.json in this project's
 * seed schema, combining two sources:
 *
 * - Arabic text (Uthmani Hafs script), juz, and page number: the
 *   project owner's own "Al-Quran Hafazan System"
 *   (hafazan.rcaquacycle.com/api/v1/surahs/{n}/ayat), a separate project
 *   they own and explicitly directed this app to use — see
 *   content/seed/SOURCES.md for the full sourcing note. Previously this
 *   came from api.quran.com's mirror of the Tanzil Project's Uthmani
 *   text; both are the same standard Uthmani Hafs script, just a
 *   different (now first-party) source.
 * - English translation and chapter metadata (name, revelation place):
 *   still the official quran.com API (api.quran.com) — Hafazan's own
 *   translation is Malay, not applicable to this English-speaking app,
 *   so translation sourcing is unchanged. Default is Pickthall
 *   (translation_id 19) — a public-domain (pre-1964, non-renewed US
 *   copyright) English translation, chosen specifically to avoid the
 *   licensing risk of modern translations like Saheeh International,
 *   which are not freely redistributable.
 *
 * This is a content-authoring tool run locally to produce static seed
 * files — the shipped app never calls either API at runtime.
 */
class ImportQuranContent extends Command
{
    protected $signature = 'quran:import
        {surahs* : Chapter numbers to import (e.g. 78 79 80)}
        {--translation=19 : quran.com translation resource id (19=Pickthall, 22=Yusuf Ali, 20=Saheeh International)}
        {--translator-name=Pickthall : Label stored in the translations array}
        {--hafazan-base=https://hafazan.rcaquacycle.com : Base URL for the Hafazan Arabic-text API}';

    protected $description = 'Import Quran surahs (Hafazan Arabic text + quran.com translation) into content/seed/quran/*.json';

    public function handle(): int
    {
        $translationId = (string) $this->option('translation');
        $translatorName = $this->option('translator-name');
        $hafazanBase = rtrim((string) $this->option('hafazan-base'), '/');
        $outputDir = base_path('content/seed/quran');

        foreach ($this->argument('surahs') as $number) {
            $number = (int) $number;
            $this->info("Fetching surah {$number}...");

            $chapter = Http::get("https://api.quran.com/api/v4/chapters/{$number}", ['language' => 'en'])
                ->throw()->json('chapter');

            $verses = Http::get("https://api.quran.com/api/v4/verses/by_chapter/{$number}", [
                'translations' => $translationId,
                'per_page' => 300,
            ])->throw()->json('verses');

            $hafazanAyat = Http::get("{$hafazanBase}/api/v1/surahs/{$number}/ayat")
                ->throw()->json('data');

            $arabicByAyahNumber = [];
            foreach ($hafazanAyat as $ayah) {
                $arabicByAyahNumber[$ayah['number_in_surah']] = $ayah;
            }

            $ayahs = array_map(function (array $verse) use ($translatorName, $arabicByAyahNumber, $number) {
                $text = $verse['translations'][0]['text'] ?? '';
                $text = trim(html_entity_decode(strip_tags($text)));

                $ayahNumber = $verse['verse_number'];
                $hafazanAyah = $arabicByAyahNumber[$ayahNumber] ?? null;
                if ($hafazanAyah === null) {
                    throw new \RuntimeException("Hafazan API has no ayah {$ayahNumber} for surah {$number} — aborting to avoid falling back to a different text source mid-surah.");
                }

                return [
                    'number_in_surah' => $ayahNumber,
                    'juz' => $hafazanAyah['juz_number'] ?? $verse['juz_number'],
                    'page' => $hafazanAyah['page_number'] ?? $verse['page_number'],
                    'arabic_text' => trim($hafazanAyah['text_arabic_uthmani']),
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
                    '%s ("%s") is a %s surah of %d ayahs. Arabic text: Al-Quran Hafazan System (Uthmani Hafs script). Translation: %s (public domain).',
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
