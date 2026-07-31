<?php

namespace App\Filament\Resources;

use App\Filament\Resources\HadithResource\Pages;
use App\Models\Hadith;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class HadithResource extends Resource
{
    protected static ?string $model = Hadith::class;

    protected static ?string $navigationIcon = 'heroicon-o-book-open';

    protected static ?string $navigationGroup = 'Hadith';

    protected static ?int $navigationSort = 2;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('hadith_collection_id')
                    ->label('Collection')
                    ->relationship('collection', 'title')
                    ->required(),
                Forms\Components\TextInput::make('number_in_collection')
                    ->label('Number')
                    ->required()
                    ->numeric(),
                Forms\Components\TextInput::make('narrator')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Select::make('authenticity_grade')
                    ->options([
                        'sahih' => 'Sahih',
                        'hasan' => 'Hasan',
                        'daif' => 'Da\'if',
                    ])
                    ->default('sahih')
                    ->required(),
                Forms\Components\Textarea::make('arabic_text')
                    ->label('Arabic text')
                    ->rows(3)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('english_text')
                    ->label('English translation')
                    ->required()
                    ->rows(3)
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('reference_note')
                    ->label('Reference')
                    ->helperText('e.g. "Related by Bukhari and Muslim"')
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('context')
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('explanation')
                    ->rows(3)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('practical_application')
                    ->rows(2)
                    ->columnSpanFull(),
            ])
            ->columns(2);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('collection.title')
                    ->label('Collection')
                    ->sortable(),
                Tables\Columns\TextColumn::make('number_in_collection')
                    ->label('#')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('narrator')->searchable(),
                Tables\Columns\TextColumn::make('authenticity_grade')
                    ->label('Grade')
                    ->badge(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('hadith_collection_id')
                    ->label('Collection')
                    ->relationship('collection', 'title'),
                Tables\Filters\SelectFilter::make('authenticity_grade')
                    ->options([
                        'sahih' => 'Sahih',
                        'hasan' => 'Hasan',
                        'daif' => 'Da\'if',
                    ]),
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
            'index' => Pages\ListHadiths::route('/'),
            'create' => Pages\CreateHadith::route('/create'),
            'edit' => Pages\EditHadith::route('/{record}/edit'),
        ];
    }
}
