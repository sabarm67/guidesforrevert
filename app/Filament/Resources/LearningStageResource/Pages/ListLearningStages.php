<?php

namespace App\Filament\Resources\LearningStageResource\Pages;

use App\Filament\Resources\LearningStageResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListLearningStages extends ListRecords
{
    protected static string $resource = LearningStageResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
