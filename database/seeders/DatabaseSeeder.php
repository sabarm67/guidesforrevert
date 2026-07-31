<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            StageLessonSeeder::class,
            DuaSeeder::class,
            QuranSeeder::class,
            HadithSeeder::class,
            AiFaqSeeder::class,
        ]);

        // Convenience test user for local development only — factories
        // depend on fakerphp/faker, a dev-only dependency not installed in
        // production (`composer install --no-dev`), so calling this
        // outside local breaks `php artisan db:seed` in production.
        if (app()->environment('local')) {
            User::factory()->create([
                'name' => 'Test User',
                'email' => 'test@example.com',
            ]);
        }
    }
}
