<?php

namespace App\Services;

use App\Models\Dua;
use Carbon\CarbonInterface;
use Illuminate\Support\Facades\Date;

class DailyDuaSelector
{
    /**
     * Deterministically pick "today's dua" from the featured set, using
     * dayOfYear % count so every device/user sees the same dua on a given
     * calendar day without any server-side state, and the Flutter client
     * can mirror the exact same calculation offline.
     */
    public function forDate(?CarbonInterface $date = null): ?Dua
    {
        $date ??= Date::now();

        $featured = Dua::where('is_daily_featured', true)->orderBy('id')->get();

        if ($featured->isEmpty()) {
            return null;
        }

        $index = $date->dayOfYear % $featured->count();

        return $featured[$index];
    }
}
