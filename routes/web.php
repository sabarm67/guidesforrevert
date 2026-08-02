<?php

use Illuminate\Support\Facades\Route;

// The Flutter Web/PWA build lives in public/ (committed pre-built — see
// docs/setup/dev-setup.md) and is served at the site root. In most nginx
// configs a literal public/index.html is matched by try_files before this
// route is ever reached, but Forge's exact `index` directive isn't
// something we can inspect from here — this route is a safety net so root
// access works either way, rather than depending on server config we can't
// verify.
Route::get('/', function () {
    return response()->file(public_path('index.html'));
});

Route::get('/status', function () {
    return response()->json([
        'name' => config('app.name'),
        'status' => 'ok',
        'api' => '/api/v1',
    ]);
});
