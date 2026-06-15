<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Destination;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index(Destination $destination)
    {
        return $destination->reviews()
            ->with('user:id,name,avatar')
            ->latest()
            ->get();
    }

    public function store(Request $request, Destination $destination)
    {
        $data = $request->validate([
            'rating' => ['required', 'integer', 'min:1', 'max:5'],
            'comment' => ['nullable', 'string'],
        ]);

        $review = Review::updateOrCreate(
            ['user_id' => $request->user()->id, 'destination_id' => $destination->id],
            ['rating' => $data['rating'], 'comment' => $data['comment'] ?? null],
        );

        $destination->recalcRating();

        return response()->json($review->load('user:id,name,avatar'), 201);
    }

    public function update(Request $request, Review $review)
    {
        $this->authorizeOwner($request, $review);

        $data = $request->validate([
            'rating' => ['sometimes', 'integer', 'min:1', 'max:5'],
            'comment' => ['nullable', 'string'],
        ]);

        $review->update($data);
        $review->destination->recalcRating();

        return response()->json($review->load('user:id,name,avatar'));
    }

    public function destroy(Request $request, Review $review)
    {
        // owner or admin may delete (admin = moderation)
        if (! $request->user()->isAdmin() && $review->user_id !== $request->user()->id) {
            abort(403, 'Forbidden.');
        }

        $destination = $review->destination;
        $review->delete();
        $destination->recalcRating();

        return response()->json(['message' => 'Review deleted.']);
    }

    private function authorizeOwner(Request $request, Review $review): void
    {
        if ($review->user_id !== $request->user()->id) {
            abort(403, 'Forbidden.');
        }
    }
}