<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Facility extends Model
{
    protected $fillable = ['name', 'icon'];

    public function destinations(): BelongsToMany
    {
        return $this->belongsToMany(Destination::class, 'destination_facilities')->withTimestamps();
    }
}