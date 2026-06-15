<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Destination;
use App\Models\Wishlist;
use Illuminate\Http\Request;

class WishlistController extends Controller
{
    public function index(Request $request)
    {
        return $request->user()
            ->wishlists()
            ->with('destination.category')
            ->latest()
            ->get();
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'destination_id' => ['required', 'exists:destinations,id'],
        ]);

        $wishlist = Wishlist::firstOrCreate([
            'user_id' => $request->user()->id,
            'destination_id' => $data['destination_id'],
        ]);

        return response()->json($wishlist->load('destination'), 201);
    }

    public function toggle(Request $request)
    {
        $data = $request->validate([
            'destination_id' => ['required', 'exists:destinations,id'],
        ]);

        $existing = Wishlist::where('user_id', $request->user()->id)
            ->where('destination_id', $data['destination_id'])
            ->first();

        if ($existing) {
            $existing->delete();

            return response()->json(['wishlisted' => false]);
        }

        Wishlist::create([
            'user_id' => $request->user()->id,
            'destination_id' => $data['destination_id'],
        ]);

        return response()->json(['wishlisted' => true]);
    }

    public function destroy(Request $request, Destination $destination)
    {
        Wishlist::where('user_id', $request->user()->id)
            ->where('destination_id', $destination->id)
            ->delete();

        return response()->json(['message' => 'Removed from wishlist.']);
    }
}