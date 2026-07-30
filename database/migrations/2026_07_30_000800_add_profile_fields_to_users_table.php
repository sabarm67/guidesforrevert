<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->enum('background_type', ['raised_muslim', 'revert', 'exploring', 'other'])
                ->default('other')->after('password');
            $table->string('locale', 10)->default('en')->after('background_type');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['background_type', 'locale']);
        });
    }
};
