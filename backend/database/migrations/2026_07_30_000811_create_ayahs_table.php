<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ayahs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('surah_id')->constrained()->cascadeOnDelete();
            $table->unsignedInteger('number_in_surah');
            $table->unsignedInteger('juz')->nullable();
            $table->unsignedInteger('page')->nullable();
            $table->text('arabic_text');
            $table->timestamps();

            $table->unique(['surah_id', 'number_in_surah']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ayahs');
    }
};
