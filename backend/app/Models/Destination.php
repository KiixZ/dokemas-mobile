<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Facades\Storage;

class Destination extends Model
{
    protected $fillable = [
        'category_id', 'name', 'slug', 'description', 'address',
        'latitude', 'longitude', 'price', 'opening_hours', 'phone',
        'thumbnail', 'rating_avg', 'rating_count', 'is_popular',
    ];

    protected $appends = ['thumbnail_url'];

    protected function thumbnailUrl(): Attribute
    {
        return Attribute::get(fn (mixed $value, array $attributes) => !empty($attributes['thumbnail']) ? Storage::disk('public')->url($attributes['thumbnail']) : null);
    }

    protected function casts(): array
    {
        return [
            'latitude' => 'float',
            'longitude' => 'float',
            'price' => 'float',
            'rating_avg' => 'float',
            'is_popular' => 'boolean',
        ];
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }

    public function images(): HasMany
    {
        return $this->hasMany(DestinationImage::class);
    }

    public function facilities(): BelongsToMany
    {
        return $this->belongsToMany(Facility::class, 'destination_facilities')->withTimestamps();
    }

    public function wishlists(): HasMany
    {
        return $this->hasMany(Wishlist::class);
    }

    public function recalcRating(): void
    {
        $publicReviews = $this->reviews()->where('status', 'public');
        $this->rating_avg = (float) round($publicReviews->avg('rating') ?? 0, 2);
        $this->rating_count = $publicReviews->count();
        $this->save();
    }
}