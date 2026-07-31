<?php

namespace App\Filament\Resources;

use App\Filament\Resources\DuaResource\Pages;
use App\Models\Dua;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class DuaResource extends Resource
{
    protected static ?string $model = Dua::class;

    protected static ?string $navigationIcon = 'heroicon-o-sparkles';

    protected static ?string $navigationGroup = 'Dua Library';

    protected static ?int $navigationSort = 2;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('dua_category_id')
                    ->label('Category')
                    ->relationship('category', 'title')
                    ->required(),
                Forms\Components\TextInput::make('title')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Textarea::make('arabic_text')
                    ->label('Arabic text')
                    ->required()
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('transliteration')
                    ->required()
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('translation')
                    ->required()
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('reference')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Select::make('authenticity')
                    ->options([
                        'quran' => 'Quran',
                        'sahih' => 'Sahih',
                        'hasan' => 'Hasan',
                    ])
                    ->default('sahih')
                    ->required(),
                Forms\Components\TextInput::make('order')
                    ->required()
                    ->numeric()
                    ->default(1),
                Forms\Components\Textarea::make('benefits')
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\FileUpload::make('audio_url')
                    ->label('Audio recitation')
                    ->directory('dua-audio')
                    ->acceptedFileTypes(['audio/mpeg', 'audio/mp4', 'audio/wav'])
                    ->helperText('Optional audio recitation file.'),
                Forms\Components\Toggle::make('is_daily_featured')
                    ->label('Include in "Today\'s Dua" rotation')
                    ->default(false),
            ])
            ->columns(2);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('order')
            ->columns([
                Tables\Columns\TextColumn::make('category.title')
                    ->label('Category')
                    ->sortable(),
                Tables\Columns\TextColumn::make('title')->searchable(),
                Tables\Columns\TextColumn::make('reference')->searchable(),
                Tables\Columns\TextColumn::make('authenticity'),
                Tables\Columns\IconColumn::make('is_daily_featured')
                    ->label('Daily')
                    ->boolean(),
                Tables\Columns\TextColumn::make('order')->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('dua_category_id')
                    ->label('Category')
                    ->relationship('category', 'title'),
                Tables\Filters\TernaryFilter::make('is_daily_featured'),
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
            'index' => Pages\ListDuas::route('/'),
            'create' => Pages\CreateDua::route('/create'),
            'edit' => Pages\EditDua::route('/{record}/edit'),
        ];
    }
}
