<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LessonResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'slug' => $this->slug,
            'order' => $this->order,
            'title' => $this->title,
            'summary' => $this->summary,
            'estimated_minutes' => $this->estimated_minutes,
            'need_to_know' => $this->need_to_know,
            'body' => $this->body,
        ];
    }
}
