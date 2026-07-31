<?php

namespace App\Filament\Resources\LearningStageResource\Pages;

use App\Filament\Resources\LearningStageResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditLearningStage extends EditRecord
{
    protected static string $resource = LearningStageResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
