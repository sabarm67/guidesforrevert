<?php

namespace App\Filament\Resources\HadithCollectionResource\Pages;

use App\Filament\Resources\HadithCollectionResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditHadithCollection extends EditRecord
{
    protected static string $resource = HadithCollectionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
