<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\DuaResource;
use App\Services\DailyDuaSelector;
use Illuminate\Http\JsonResponse;

class DuaController extends Controller
{
    public function daily(DailyDuaSelector $selector): JsonResponse
    {
        $dua = $selector->forDate();

        if (! $dua) {
            return response()->json(['message' => 'No featured duas available.'], 404);
        }

        return response()->json([
            'data' => new DuaResource($dua),
        ]);
    }
}
