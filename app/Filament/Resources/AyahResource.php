<?php

namespace App\Filament\Resources;

use App\Filament\Resources\AyahResource\Pages;
use App\Models\Ayah;
use App\Models\Surah;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class AyahResource extends Resource
{
    protected static ?string $model = Ayah::class;

    protected static ?string $navigationIcon = 'heroicon-o-document-text';

    protected static ?string $navigationGroup = 'Quran';

    protected static ?int $navigationSort = 2;

    /**
     * Word-by-word (ayahs.words) editing is not included here — it's only
     * seeded for Al-Fatihah ayah 1 in the Foundation Package and is future
     * work to build a dedicated UI for (see docs/architecture/er-diagram.md).
     *
     * This is a top-level resource rather than a Surah relation manager —
     * a nested relation manager here hit a reproducible Filament/Livewire
     * hydration bug (`RelationManager::$table` typed-property-access error
     * on the second, deferred-load request) specific to this Filament
     * 3.3.54 / Laravel 13.23 combination. Every other resource in this app
     * works fine; only the nested-relation-manager pattern triggered it.
     */
    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('surah_id')
                    ->label('Surah')
                    ->relationship('surah', 'name_english')
                    ->getOptionLabelFromRecordUsing(fn (Surah $record) => "{$record->number}. {$record->name_english} ({$record->name_transliteration})")
                    ->searchable()
                    ->required(),
                Forms\Components\TextInput::make('number_in_surah')
                    ->label('Ayah number')
                    ->required()
                    ->numeric(),
                Forms\Components\TextInput::make('juz')
                    ->numeric(),
                Forms\Components\TextInput::make('page')
                    ->numeric(),
                Forms\Components\Textarea::make('arabic_text')
                    ->required()
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\Repeater::make('translations')
                    ->relationship()
                    ->schema([
                        Forms\Components\TextInput::make('translator')
                            ->default('Saheeh International')
                            ->required(),
                        Forms\Components\Textarea::make('text')
                            ->required()
                            ->rows(2),
                    ])
                    ->columns(1)
                    ->columnSpanFull()
                    ->addActionLabel('Add translation'),
                Forms\Components\Repeater::make('tafsirs')
                    ->relationship()
                    ->schema([
                        Forms\Components\Select::make('source')
                            ->options(['ibn_kathir' => 'Ibn Kathir', 'al_sadi' => 'Al-Sa\'di'])
                            ->required(),
                        Forms\Components\Textarea::make('text_summary')
                            ->required()
                            ->rows(3),
                    ])
                    ->columns(1)
                    ->columnSpanFull()
                    ->addActionLabel('Add tafsir summary'),
            ])
            ->columns(3);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('number_in_surah')
            ->columns([
                Tables\Columns\TextColumn::make('surah.name_english')
                    ->label('Surah')
                    ->sortable(),
                Tables\Columns\TextColumn::make('number_in_surah')->label('#'),
                Tables\Columns\TextColumn::make('arabic_text')->limit(50),
                Tables\Columns\TextColumn::make('translations_count')
                    ->counts('translations')
                    ->label('Translations'),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('surah_id')
                    ->label('Surah')
                    ->relationship('surah', 'name_english'),
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
            'index' => Pages\ListAyahs::route('/'),
            'create' => Pages\CreateAyah::route('/create'),
            'edit' => Pages\EditAyah::route('/{record}/edit'),
        ];
    }
}
