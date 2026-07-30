<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LearningStageResource;
use App\Http\Resources\LessonSummaryResource;
use App\Models\LearningStage;
use Illuminate\Http\JsonResponse;

class LearningStageController extends Controller
{
    public function index(): JsonResponse
    {
        $stages = LearningStage::with('lessons')->orderBy('order')->get();

        return response()->json([
            'data' => LearningStageResource::collection($stages),
        ]);
    }

    public function lessons(string $slug): JsonResponse
    {
        $stage = LearningStage::where('slug', $slug)->firstOrFail();

        return response()->json([
            'data' => LessonSummaryResource::collection($stage->lessons),
        ]);
    }
}
