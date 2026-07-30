<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('lessons', function (Blueprint $table) {
            $table->id();
            $table->foreignId('learning_stage_id')->constrained()->restrictOnDelete();
            $table->string('slug')->unique();
            $table->unsignedInteger('order');
            $table->string('title');
            $table->text('summary')->nullable();
            $table->json('body');
            $table->unsignedInteger('estimated_minutes')->default(5);
            $table->boolean('need_to_know')->default(true);
            $table->boolean('is_published')->default(true);
            $table->unsignedInteger('version')->default(1);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lessons');
    }
};
