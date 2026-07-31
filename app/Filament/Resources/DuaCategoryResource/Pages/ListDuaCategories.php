<?php

namespace App\Filament\Resources\DuaCategoryResource\Pages;

use App\Filament\Resources\DuaCategoryResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListDuaCategories extends ListRecords
{
    protected static string $resource = DuaCategoryResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
