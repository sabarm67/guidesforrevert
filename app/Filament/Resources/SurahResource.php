<?php

namespace App\Filament\Resources;

use App\Filament\Resources\SurahResource\Pages;
use App\Models\Surah;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class SurahResource extends Resource
{
    protected static ?string $model = Surah::class;

    protected static ?string $navigationIcon = 'heroicon-o-book-open';

    protected static ?string $navigationGroup = 'Quran';

    protected static ?int $navigationSort = 1;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('number')
                    ->required()
                    ->numeric()
                    ->minValue(1)
                    ->maxValue(114)
                    ->unique(ignoreRecord: true),
                Forms\Components\Select::make('revelation_type')
                    ->options(['meccan' => 'Meccan', 'medinan' => 'Medinan'])
                    ->required(),
                Forms\Components\TextInput::make('name_arabic')
                    ->label('Name (Arabic)')
                    ->required(),
                Forms\Components\TextInput::make('name_english')
                    ->label('Name (English)')
                    ->required(),
                Forms\Components\TextInput::make('name_transliteration')
                    ->label('Name (transliteration)')
                    ->required(),
                Forms\Components\TextInput::make('ayah_count')
                    ->required()
                    ->numeric()
                    ->default(0)
                    ->helperText('Kept in sync manually — update this if you add/remove ayahs.'),
                Forms\Components\Textarea::make('beginner_intro')
                    ->rows(3)
                    ->columnSpanFull(),
            ])
            ->columns(2);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('number')
            ->columns([
                Tables\Columns\TextColumn::make('number')->sortable(),
                Tables\Columns\TextColumn::make('name_english')->searchable(),
                Tables\Columns\TextColumn::make('name_transliteration')->searchable(),
                Tables\Columns\TextColumn::make('revelation_type')->badge(),
                Tables\Columns\TextColumn::make('ayahs_count')
                    ->counts('ayahs')
                    ->label('Ayahs entered'),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('revelation_type')
                    ->options(['meccan' => 'Meccan', 'medinan' => 'Medinan']),
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
            'index' => Pages\ListSurahs::route('/'),
            'create' => Pages\CreateSurah::route('/create'),
            'edit' => Pages\EditSurah::route('/{record}/edit'),
        ];
    }
}
