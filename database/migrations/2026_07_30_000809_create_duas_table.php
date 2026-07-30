<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('duas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('dua_category_id')->constrained()->restrictOnDelete();
            $table->string('title');
            $table->text('arabic_text');
            $table->text('transliteration');
            $table->text('translation');
            $table->string('reference');
            $table->enum('authenticity', ['quran', 'sahih', 'hasan'])->default('sahih');
            $table->text('benefits')->nullable();
            $table->string('audio_url')->nullable();
            $table->boolean('is_daily_featured')->default(false);
            $table->unsignedInteger('order')->default(1);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('duas');
    }
};
