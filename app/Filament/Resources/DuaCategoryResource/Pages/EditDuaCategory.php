<?php

namespace App\Filament\Resources\DuaCategoryResource\Pages;

use App\Filament\Resources\DuaCategoryResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditDuaCategory extends EditRecord
{
    protected static string $resource = DuaCategoryResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
