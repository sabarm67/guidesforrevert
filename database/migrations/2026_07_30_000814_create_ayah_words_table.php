<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ayah_words', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ayah_id')->constrained()->cascadeOnDelete();
            $table->unsignedInteger('position');
            $table->string('arabic_word');
            $table->string('transliteration');
            $table->string('translation');
            $table->timestamps();

            $table->unique(['ayah_id', 'position']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ayah_words');
    }
};
