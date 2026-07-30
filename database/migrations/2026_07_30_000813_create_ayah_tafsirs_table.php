<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ayah_tafsirs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ayah_id')->constrained()->cascadeOnDelete();
            $table->enum('source', ['ibn_kathir', 'al_sadi']);
            $table->text('text_summary');
            $table->timestamps();

            $table->unique(['ayah_id', 'source']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ayah_tafsirs');
    }
};
