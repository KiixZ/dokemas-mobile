<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Destination;
use App\Models\Facility;
use App\Models\Review;
use App\Models\User;

class DashboardController extends Controller
{
    public function __invoke()
    {
        return response()->json([
            'total_destinations' => Destination::count(),
            'total_users' => User::where('role', 'user')->count(),
            'total_reviews' => Review::count(),
            'total_categories' => Category::count(),
            'total_facilities' => Facility::count(),
            'latest_reviews' => Review::with(['user:id,name', 'destination:id,name'])
                ->latest()
                ->limit(5)
                ->get(),
            'top_destinations' => Destination::orderByDesc('rating_avg')
                ->limit(5)
                ->get(['id', 'name', 'rating_avg', 'rating_count']),
        ]);
    }
}