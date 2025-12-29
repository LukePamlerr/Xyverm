<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('migration_mappings', function (Blueprint $table) {
            $table->id();
            $table->string('source_type');
            $table->string('source_id');
            $table->string('target_type');
            $table->string('target_id');
            $table->json('meta')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('migration_mappings');
    }
};
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('migration_mappings', function (Blueprint $table) {
            $table->id();
            $table->string('source_type');
            $table->string('source_id');
            $table->string('target_type');
            $table->string('target_id');
            $table->json('meta')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('migration_mappings');
    }
};
