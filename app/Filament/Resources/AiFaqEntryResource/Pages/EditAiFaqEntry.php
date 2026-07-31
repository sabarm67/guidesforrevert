<?php

namespace App\Filament\Resources\AiFaqEntryResource\Pages;

use App\Filament\Resources\AiFaqEntryResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditAiFaqEntry extends EditRecord
{
    protected static string $resource = AiFaqEntryResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
