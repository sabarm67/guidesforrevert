<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ai_faq_entries', function (Blueprint $table) {
            $table->id();
            $table->string('faq_key')->unique();
            $table->string('canonical_question');
            $table->json('question_variants');
            $table->json('keywords');
            $table->string('category');
            $table->text('answer_text');
            $table->json('source_citations');
            $table->enum('confidence', ['general_guidance', 'requires_scholar'])->default('general_guidance');
            $table->boolean('requires_scholar_disclaimer')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ai_faq_entries');
    }
};
