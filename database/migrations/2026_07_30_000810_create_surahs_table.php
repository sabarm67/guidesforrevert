<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('surahs', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('number')->unique();
            $table->string('name_arabic');
            $table->string('name_english');
            $table->string('name_transliteration');
            $table->enum('revelation_type', ['meccan', 'medinan']);
            $table->unsignedInteger('ayah_count')->default(0);
            $table->text('beginner_intro')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('surahs');
    }
};
