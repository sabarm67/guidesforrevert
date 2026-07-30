<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DuaResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'arabic_text' => $this->arabic_text,
            'transliteration' => $this->transliteration,
            'translation' => $this->translation,
            'reference' => $this->reference,
            'authenticity' => $this->authenticity,
            'benefits' => $this->benefits,
            'category' => $this->whenLoaded('category', fn () => $this->category->slug),
        ];
    }
}
