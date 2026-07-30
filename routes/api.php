<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DuaController;
use App\Http\Controllers\Api\LearningStageController;
use App\Http\Controllers\Api\LessonController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);

        Route::middleware('auth:sanctum')->group(function () {
            Route::post('logout', [AuthController::class, 'logout']);
            Route::get('me', [AuthController::class, 'me']);
        });
    });

    Route::get('learning-stages', [LearningStageController::class, 'index']);
    Route::get('learning-stages/{slug}/lessons', [LearningStageController::class, 'lessons']);
    Route::get('lessons/{lesson}', [LessonController::class, 'show']);

    Route::get('duas/daily', [DuaController::class, 'daily']);
});
