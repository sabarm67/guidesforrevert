<?php

namespace Database\Seeders;

use App\Models\LearningStage;
use App\Models\Lesson;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;

class StageLessonSeeder extends Seeder
{
    public function run(): void
    {
        $seedPath = base_path('content/seed');

        $stages = json_decode(File::get("{$seedPath}/stages.json"), true);

        foreach ($stages as $stageData) {
            LearningStage::updateOrCreate(
                ['slug' => $stageData['slug']],
                $stageData,
            );
        }

        $lessonFiles = File::glob("{$seedPath}/lessons/*.json");

        foreach ($lessonFiles as $file) {
            $lessonData = json_decode(File::get($file), true);

            $stage = LearningStage::where('slug', $lessonData['stage_slug'])->first();

            if (! $stage) {
                continue;
            }

            Lesson::updateOrCreate(
                ['slug' => $lessonData['slug']],
                [
                    'learning_stage_id' => $stage->id,
                    'order' => $lessonData['order'],
                    'title' => $lessonData['title'],
                    'summary' => $lessonData['summary'],
                    'body' => $lessonData['body'],
                    'estimated_minutes' => $lessonData['estimated_minutes'],
                    'need_to_know' => $lessonData['need_to_know'] ?? true,
                ],
            );
        }
    }
}
