<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    /**
     * Display a listing of all reviews for admin.
     */
    public function index()
    {
        $reviews = Review::with(['user:id,name,avatar', 'destination:id,name'])
            ->latest()
            ->paginate(20);

        return response()->json($reviews);
    }

    /**
     * Update the status of a review.
     */
    public function updateStatus(Request $request, Review $review)
    {
        $data = $request->validate([
            'status' => 'required|in:pending,public,hidden,reported',
            'flag_reason' => 'nullable|string',
            'flag_count' => 'nullable|integer'
        ]);

        $review->update($data);
        
        if ($review->destination) {
            $review->destination->recalcRating();
        }

        return response()->json($review->load(['user:id,name,avatar', 'destination:id,name']));
    }

    /**
     * Remove the specified review from storage.
     */
    public function destroy(Review $review)
    {
        $destination = $review->destination;
        $review->delete();
        if ($destination) {
            $destination->recalcRating();
        }

        return response()->json(['message' => 'Review deleted.']);
    }
}
