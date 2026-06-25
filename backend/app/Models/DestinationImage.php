<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

class DestinationImage extends Model
{
    protected $fillable = ['destination_id', 'image_path', 'caption'];

    protected $appends = ['image_url'];

    protected function imageUrl(): Attribute
    {
        return Attribute::get(fn (mixed $value, array $attributes) => !empty($attributes['image_path']) ? Storage::disk('public')->url($attributes['image_path']) : null);
    }

    public function destination(): BelongsTo
    {
        return $this->belongsTo(Destination::class);
    }
}