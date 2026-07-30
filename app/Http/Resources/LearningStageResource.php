<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LearningStageResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'slug' => $this->slug,
            'order' => $this->order,
            'title' => $this->title,
            'description' => $this->description,
            'icon' => $this->icon,
            'lessons' => LessonSummaryResource::collection($this->whenLoaded('lessons')),
        ];
    }
}
