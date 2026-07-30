<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ayah_translations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('ayah_id')->constrained()->cascadeOnDelete();
            $table->string('translator')->default('Saheeh International');
            $table->text('text');
            $table->timestamps();

            $table->unique(['ayah_id', 'translator']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ayah_translations');
    }
};
