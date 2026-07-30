<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('hadiths', function (Blueprint $table) {
            $table->id();
            $table->foreignId('hadith_collection_id')->constrained()->cascadeOnDelete();
            $table->unsignedInteger('number_in_collection');
            $table->text('arabic_text')->nullable();
            $table->text('english_text');
            $table->string('narrator');
            $table->enum('authenticity_grade', ['sahih', 'hasan', 'daif'])->default('sahih');
            $table->text('reference_note')->nullable();
            $table->text('context')->nullable();
            $table->text('explanation')->nullable();
            $table->text('practical_application')->nullable();
            $table->timestamps();

            $table->unique(['hadith_collection_id', 'number_in_collection']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('hadiths');
    }
};
