<?php

namespace App\Filament\Resources\LessonResource\Pages;

use App\Filament\Resources\LessonResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditLesson extends EditRecord
{
    protected static string $resource = LessonResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $data['body'] = LessonResource::bodyToBuilderFormat($data['body'] ?? []);

        return $data;
    }

    protected function mutateFormDataBeforeSave(array $data): array
    {
        $data['body'] = LessonResource::bodyToFlatFormat($data['body'] ?? []);

        return $data;
    }
}
