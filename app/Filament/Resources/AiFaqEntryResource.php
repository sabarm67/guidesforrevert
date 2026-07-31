<?php

namespace App\Filament\Resources;

use App\Filament\Resources\AiFaqEntryResource\Pages;
use App\Models\AiFaqEntry;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class AiFaqEntryResource extends Resource
{
    protected static ?string $model = AiFaqEntry::class;

    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left-right';

    protected static ?string $navigationGroup = 'AI Mentor';

    protected static ?string $modelLabel = 'FAQ entry';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('faq_key')
                    ->label('Key')
                    ->required()
                    ->maxLength(255)
                    ->unique(ignoreRecord: true)
                    ->helperText('Stable identifier, e.g. "faq_family_disclosure_001". Never reuse a retired key.'),
                Forms\Components\TextInput::make('category')
                    ->required()
                    ->maxLength(255)
                    ->helperText('e.g. "family_and_social", "belief", "quran_and_learning"'),
                Forms\Components\TextInput::make('canonical_question')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('answer_text')
                    ->required()
                    ->rows(4)
                    ->columnSpanFull(),
                Forms\Components\TagsInput::make('question_variants')
                    ->label('Question variants')
                    ->helperText('Alternative phrasings the on-device matcher should also recognise.')
                    ->required()
                    ->columnSpanFull(),
                Forms\Components\TagsInput::make('keywords')
                    ->helperText('The most important matching signal — weighted highest by the matcher.')
                    ->required()
                    ->columnSpanFull(),
                Forms\Components\Select::make('confidence')
                    ->options([
                        'general_guidance' => 'General guidance',
                        'requires_scholar' => 'Requires scholar',
                    ])
                    ->default('general_guidance')
                    ->required()
                    ->helperText('"Requires scholar" always shows the consult-a-scholar disclaimer, regardless of the toggle below.'),
                Forms\Components\Toggle::make('requires_scholar_disclaimer')
                    ->label('Force scholar disclaimer'),
                Forms\Components\Repeater::make('source_citations')
                    ->label('Sources')
                    ->schema([
                        Forms\Components\Select::make('type')
                            ->options([
                                'lesson' => 'Lesson',
                                'dua' => 'Dua',
                                'hadith' => 'Hadith',
                                'quran' => 'Quran',
                            ])
                            ->required(),
                        Forms\Components\TextInput::make('label')
                            ->required()
                            ->helperText('Display text shown in the app, e.g. "Lesson: Who is Allah?"'),
                        Forms\Components\TextInput::make('id')
                            ->helperText('Lesson slug, if type is "lesson".'),
                        Forms\Components\TextInput::make('collection')
                            ->helperText('Hadith collection slug, if type is "hadith".'),
                        Forms\Components\TextInput::make('number')
                            ->numeric()
                            ->helperText('Hadith number, if type is "hadith".'),
                    ])
                    ->columns(2)
                    ->columnSpanFull()
                    ->addActionLabel('Add source'),
            ])
            ->columns(2);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('faq_key')->label('Key')->searchable(),
                Tables\Columns\TextColumn::make('canonical_question')
                    ->searchable()
                    ->limit(60),
                Tables\Columns\TextColumn::make('category'),
                Tables\Columns\TextColumn::make('confidence')->badge(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('confidence')
                    ->options([
                        'general_guidance' => 'General guidance',
                        'requires_scholar' => 'Requires scholar',
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
            'index' => Pages\ListAiFaqEntries::route('/'),
            'create' => Pages\CreateAiFaqEntry::route('/create'),
            'edit' => Pages\EditAiFaqEntry::route('/{record}/edit'),
        ];
    }
}
