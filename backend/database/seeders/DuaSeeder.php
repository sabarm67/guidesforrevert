<?php

namespace Database\Seeders;

use App\Models\Dua;
use App\Models\DuaCategory;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class DuaSeeder extends Seeder
{
    /** Human-friendly titles for category slugs discovered in the seed data. */
    private const CATEGORY_TITLES = [
        'morning-evening' => 'Morning & Evening',
        'eating' => 'Eating & Drinking',
        'distress-and-difficulty' => 'Distress & Difficulty',
        'entering-leaving-home' => 'Entering & Leaving Home',
    ];

    public function run(): void
    {
        $seedPath = base_path('../content/seed');
        $duas = json_decode(File::get("{$seedPath}/duas.json"), true);

        $categoryOrder = [];

        foreach ($duas as $duaData) {
            $slug = $duaData['category_slug'];

            $categoryOrder[$slug] ??= count($categoryOrder) + 1;

            $category = DuaCategory::updateOrCreate(
                ['slug' => $slug],
                [
                    'title' => self::CATEGORY_TITLES[$slug] ?? Str::title(str_replace('-', ' ', $slug)),
                    'order' => $categoryOrder[$slug],
                ],
            );

            Dua::updateOrCreate(
                ['title' => $duaData['title'], 'dua_category_id' => $category->id],
                [
                    'arabic_text' => $duaData['arabic_text'],
                    'transliteration' => $duaData['transliteration'],
                    'translation' => $duaData['translation'],
                    'reference' => $duaData['reference'],
                    'authenticity' => $duaData['authenticity'] ?? 'sahih',
                    'benefits' => $duaData['benefits'] ?? null,
                    'is_daily_featured' => $duaData['is_daily_featured'] ?? false,
                    'order' => $duaData['order'] ?? 1,
                ],
            );
        }
    }
}
