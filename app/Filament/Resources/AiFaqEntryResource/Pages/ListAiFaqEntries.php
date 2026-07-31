<?php

namespace App\Filament\Resources\AiFaqEntryResource\Pages;

use App\Filament\Resources\AiFaqEntryResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListAiFaqEntries extends ListRecords
{
    protected static string $resource = AiFaqEntryResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
