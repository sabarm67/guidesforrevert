<?php

namespace Tests\Feature;

use App\Models\LearningStage;
use App\Models\Lesson;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class LearningStagesTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_lists_stages_in_order_with_nested_lessons(): void
    {
        $stageTwo = LearningStage::create([
            'slug' => 'your-first-week', 'order' => 2, 'title' => 'Your First Week',
        ]);
        $stageOne = LearningStage::create([
            'slug' => 'welcome-to-islam', 'order' => 1, 'title' => 'Welcome to Islam',
        ]);

        Lesson::create([
            'learning_stage_id' => $stageOne->id,
            'slug' => 'who-is-allah',
            'order' => 1,
            'title' => 'Who is Allah?',
            'summary' => 'Intro to Tawhid',
            'body' => [['type' => 'text', 'text' => 'placeholder']],
            'estimated_minutes' => 6,
        ]);

        $response = $this->getJson('/api/v1/learning-stages');

        $response->assertStatus(200);
        $response->assertJsonPath('data.0.slug', 'welcome-to-islam');
        $response->assertJsonPath('data.1.slug', 'your-first-week');
        $response->assertJsonPath('data.0.lessons.0.slug', 'who-is-allah');
    }

    public function test_it_lists_lessons_for_a_given_stage_slug(): void
    {
        $stage = LearningStage::create([
            'slug' => 'welcome-to-islam', 'order' => 1, 'title' => 'Welcome to Islam',
        ]);

        Lesson::create([
            'learning_stage_id' => $stage->id,
            'slug' => 'who-is-allah',
            'order' => 1,
            'title' => 'Who is Allah?',
            'body' => [['type' => 'text', 'text' => 'placeholder']],
        ]);

        $response = $this->getJson('/api/v1/learning-stages/welcome-to-islam/lessons');

        $response->assertStatus(200)->assertJsonCount(1, 'data');
    }

    public function test_unknown_stage_slug_returns_404(): void
    {
        $this->getJson('/api/v1/learning-stages/does-not-exist/lessons')->assertStatus(404);
    }

    public function test_it_shows_full_lesson_detail_including_body(): void
    {
        $stage = LearningStage::create([
            'slug' => 'welcome-to-islam', 'order' => 1, 'title' => 'Welcome to Islam',
        ]);

        $lesson = Lesson::create([
            'learning_stage_id' => $stage->id,
            'slug' => 'who-is-allah',
            'order' => 1,
            'title' => 'Who is Allah?',
            'body' => [['type' => 'heading', 'text' => 'One God']],
        ]);

        $response = $this->getJson("/api/v1/lessons/{$lesson->id}");

        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Who is Allah?')
            ->assertJsonPath('data.body.0.text', 'One God');
    }
}
