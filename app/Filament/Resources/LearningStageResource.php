<?php

namespace App\Filament\Resources;

use App\Filament\Resources\LearningStageResource\Pages;
use App\Models\LearningStage;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class LearningStageResource extends Resource
{
    protected static ?string $model = LearningStage::class;

    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    protected static ?string $navigationGroup = 'Learning Journey';

    protected static ?int $navigationSort = 1;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('title')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('slug')
                    ->required()
                    ->maxLength(255)
                    ->unique(ignoreRecord: true)
                    ->helperText('Used by the app/API to reference this stage, e.g. "welcome-to-islam".'),
                Forms\Components\TextInput::make('order')
                    ->required()
                    ->numeric()
                    ->default(1)
                    ->helperText('Controls the order stages appear in the learning journey.'),
                Forms\Components\TextInput::make('icon')
                    ->maxLength(255)
                    ->helperText('Icon identifier used by the Flutter app, e.g. "stage_welcome".'),
                Forms\Components\Textarea::make('description')
                    ->rows(3)
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('order')
            ->columns([
                Tables\Columns\TextColumn::make('order')->sortable(),
                Tables\Columns\TextColumn::make('title')->searchable(),
                Tables\Columns\TextColumn::make('slug')->searchable(),
                Tables\Columns\TextColumn::make('lessons_count')
                    ->counts('lessons')
                    ->label('Lessons'),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListLearningStages::route('/'),
            'create' => Pages\CreateLearningStage::route('/create'),
            'edit' => Pages\EditLearningStage::route('/{record}/edit'),
        ];
    }
}
