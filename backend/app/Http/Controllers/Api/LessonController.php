<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LessonResource;
use App\Models\Lesson;
use Illuminate\Http\JsonResponse;

class LessonController extends Controller
{
    public function show(Lesson $lesson): JsonResponse
    {
        return response()->json([
            'data' => new LessonResource($lesson),
        ]);
    }
}
