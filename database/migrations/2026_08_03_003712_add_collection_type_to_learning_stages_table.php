<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('learning_stages', function (Blueprint $table) {
            // Distinguishes the linear 4-stage Learning Journey ('journey')
            // from standalone, non-linear topic collections like Fiqh in
            // Daily Life and Understanding Islam: Addressing Misconceptions
            // — both reuse the existing stage/lesson structure rather than
            // introducing a parallel schema, since the content shape
            // (title, summary, ordered lessons with structured body blocks)
            // is identical.
            $table->string('collection_type')->default('journey')->after('slug');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('learning_stages', function (Blueprint $table) {
            $table->dropColumn('collection_type');
        });
    }
};
