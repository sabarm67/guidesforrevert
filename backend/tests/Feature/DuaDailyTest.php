<?php

namespace Tests\Feature;

use App\Models\Dua;
use App\Models\DuaCategory;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DuaDailyTest extends TestCase
{
    use RefreshDatabase;

    private function makeFeaturedDuas(int $count): void
    {
        $category = DuaCategory::create(['slug' => 'morning-evening', 'title' => 'Morning & Evening', 'order' => 1]);

        for ($i = 1; $i <= $count; $i++) {
            Dua::create([
                'dua_category_id' => $category->id,
                'title' => "Dua {$i}",
                'arabic_text' => 'ARABIC',
                'transliteration' => 'transliteration',
                'translation' => 'translation',
                'reference' => 'Reference',
                'authenticity' => 'sahih',
                'is_daily_featured' => true,
                'order' => $i,
            ]);
        }
    }

    public function test_it_returns_the_same_dua_for_two_calls_on_the_same_day(): void
    {
        $this->makeFeaturedDuas(3);

        Carbon::setTestNow(Carbon::parse('2026-07-30'));

        $first = $this->getJson('/api/v1/duas/daily')->json('data.title');
        $second = $this->getJson('/api/v1/duas/daily')->json('data.title');

        $this->assertSame($first, $second);

        Carbon::setTestNow();
    }

    public function test_it_can_return_a_different_dua_on_a_different_day(): void
    {
        $this->makeFeaturedDuas(3);

        Carbon::setTestNow(Carbon::parse('2026-01-01'));
        $dayOne = $this->getJson('/api/v1/duas/daily')->json('data.title');

        Carbon::setTestNow(Carbon::parse('2026-01-02'));
        $dayTwo = $this->getJson('/api/v1/duas/daily')->json('data.title');

        $this->assertNotSame($dayOne, $dayTwo);

        Carbon::setTestNow();
    }

    public function test_it_returns_404_when_no_duas_are_featured(): void
    {
        $this->getJson('/api/v1/duas/daily')->assertStatus(404);
    }
}
