<?php

namespace App\Filament\Resources;

use App\Filament\Resources\LessonResource\Pages;
use App\Models\Lesson;
use Filament\Forms;
use Filament\Forms\Components\Builder\Block;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class LessonResource extends Resource
{
    protected static ?string $model = Lesson::class;

    protected static ?string $navigationIcon = 'heroicon-o-book-open';

    protected static ?string $navigationGroup = 'Learning Journey';

    protected static ?int $navigationSort = 2;

    /**
     * The lesson body is stored (and read by the API/Flutter app) as a flat
     * array of blocks — [{type, text, ...}, ...] — see
     * content/schema/lesson.schema.json. Filament's Builder component works
     * in terms of {type, data: {...}} blocks instead, so the two page
     * classes below convert between the shapes on load/save. This method
     * defines the block schema once, shared by the form.
     */
    public static function bodyBlocks(): array
    {
        return [
            Block::make('heading')
                ->label('Heading')
                ->icon('heroicon-o-bars-3-bottom-left')
                ->schema([
                    Forms\Components\TextInput::make('text')->required(),
                ]),
            Block::make('text')
                ->label('Paragraph')
                ->icon('heroicon-o-document-text')
                ->schema([
                    Forms\Components\Textarea::make('text')->required()->rows(4),
                ]),
            Block::make('quote')
                ->label('Quote (Quran/Hadith)')
                ->icon('heroicon-o-chat-bubble-left-right')
                ->schema([
                    Forms\Components\Textarea::make('arabic')
                        ->rows(2)
                        ->helperText('Arabic text, if applicable.'),
                    Forms\Components\Textarea::make('translation')
                        ->required()
                        ->rows(2),
                    Forms\Components\TextInput::make('reference')
                        ->helperText('e.g. "Quran 112:1-4 (Saheeh International)"'),
                ]),
            Block::make('image')
                ->label('Image')
                ->icon('heroicon-o-photo')
                ->schema([
                    Forms\Components\FileUpload::make('image_ref')
                        ->label('Image')
                        ->image()
                        ->directory('lesson-images')
                        ->required(),
                    Forms\Components\TextInput::make('caption')
                        ->helperText('Optional caption shown under the image.'),
                ]),
            Block::make('video')
                ->label('Video (not yet shown in-app)')
                ->icon('heroicon-o-play-circle')
                ->schema([
                    Forms\Components\TextInput::make('video_url')
                        ->label('Video URL')
                        ->url()
                        ->required()
                        ->helperText(
                            'Schema/CMS support only for now — the Flutter app does not render '
                            .'video blocks yet, so anything added here will not appear in the app.',
                        ),
                ]),
            Block::make('faq')
                ->label('FAQ item')
                ->icon('heroicon-o-question-mark-circle')
                ->schema([
                    Forms\Components\TextInput::make('question')->required(),
                    Forms\Components\Textarea::make('answer')->required()->rows(3),
                ]),
            Block::make('reflection')
                ->label('Reflection question')
                ->icon('heroicon-o-light-bulb')
                ->schema([
                    Forms\Components\Textarea::make('question')->required()->rows(2),
                ]),
        ];
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('learning_stage_id')
                    ->label('Stage')
                    ->relationship('learningStage', 'title')
                    ->required(),
                Forms\Components\TextInput::make('slug')
                    ->required()
                    ->maxLength(255)
                    ->unique(ignoreRecord: true),
                Forms\Components\TextInput::make('order')
                    ->required()
                    ->numeric()
                    ->default(1),
                Forms\Components\TextInput::make('title')
                    ->required()
                    ->maxLength(255)
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('summary')
                    ->rows(2)
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('estimated_minutes')
                    ->required()
                    ->numeric()
                    ->default(5),
                Forms\Components\Toggle::make('need_to_know')
                    ->label('"Need to Know" (vs. "Good to Know")')
                    ->default(true),
                Forms\Components\Toggle::make('is_published')
                    ->default(true),
                Forms\Components\Builder::make('body')
                    ->label('Lesson content')
                    ->blocks(self::bodyBlocks())
                    ->addActionLabel('Add content block')
                    ->collapsible()
                    ->collapsed()
                    ->reorderable()
                    ->columnSpanFull(),
            ])
            ->columns(2);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('order')
            ->columns([
                Tables\Columns\TextColumn::make('learningStage.title')
                    ->label('Stage')
                    ->sortable(),
                Tables\Columns\TextColumn::make('order')->sortable(),
                Tables\Columns\TextColumn::make('title')->searchable(),
                Tables\Columns\TextColumn::make('estimated_minutes')
                    ->label('Minutes')
                    ->sortable(),
                Tables\Columns\IconColumn::make('need_to_know')->boolean(),
                Tables\Columns\IconColumn::make('is_published')->boolean(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('learning_stage_id')
                    ->label('Stage')
                    ->relationship('learningStage', 'title'),
                Tables\Filters\TernaryFilter::make('is_published'),
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
            'index' => Pages\ListLessons::route('/'),
            'create' => Pages\CreateLesson::route('/create'),
            'edit' => Pages\EditLesson::route('/{record}/edit'),
        ];
    }

    /**
     * Storage format (flat, e.g. {"type": "heading", "text": "..."}) ->
     * Filament Builder format ({"type": "heading", "data": {"text": "..."}}).
     */
    public static function bodyToBuilderFormat(?array $blocks): array
    {
        return collect($blocks ?? [])
            ->map(fn (array $block) => [
                'type' => $block['type'] ?? 'text',
                'data' => collect($block)->except('type')->toArray(),
            ])
            ->values()
            ->toArray();
    }

    /**
     * Filament Builder format -> flat storage format (the reverse of
     * bodyToBuilderFormat(), so the API/Flutter app's block renderer
     * doesn't need to change).
     */
    public static function bodyToFlatFormat(?array $blocks): array
    {
        return collect($blocks ?? [])
            ->map(fn (array $block) => array_merge(
                ['type' => $block['type']],
                $block['data'] ?? [],
            ))
            ->values()
            ->toArray();
    }
}
