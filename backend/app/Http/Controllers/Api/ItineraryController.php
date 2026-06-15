<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Itinerary;
use App\Models\ItineraryItem;
use Illuminate\Http\Request;

class ItineraryController extends Controller
{
    public function index(Request $request)
    {
        return $request->user()
            ->itineraries()
            ->withCount('items')
            ->latest()
            ->get();
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'start_date' => ['nullable', 'date'],
            'end_date' => ['nullable', 'date', 'after_or_equal:start_date'],
            'note' => ['nullable', 'string'],
        ]);

        $itinerary = $request->user()->itineraries()->create($data);

        return response()->json($itinerary, 201);
    }

    public function show(Request $request, Itinerary $itinerary)
    {
        $this->authorizeOwner($request, $itinerary);

        return $itinerary->load('items.destination.category');
    }

    public function update(Request $request, Itinerary $itinerary)
    {
        $this->authorizeOwner($request, $itinerary);

        $data = $request->validate([
            'title' => ['sometimes', 'string', 'max:255'],
            'start_date' => ['nullable', 'date'],
            'end_date' => ['nullable', 'date', 'after_or_equal:start_date'],
            'note' => ['nullable', 'string'],
        ]);

        $itinerary->update($data);

        return response()->json($itinerary);
    }

    public function destroy(Request $request, Itinerary $itinerary)
    {
        $this->authorizeOwner($request, $itinerary);
        $itinerary->delete();

        return response()->json(['message' => 'Itinerary deleted.']);
    }

    public function addItem(Request $request, Itinerary $itinerary)
    {
        $this->authorizeOwner($request, $itinerary);

        $data = $request->validate([
            'destination_id' => ['required', 'exists:destinations,id'],
            'visit_date' => ['nullable', 'date'],
            'visit_time' => ['nullable', 'date_format:H:i'],
            'order' => ['nullable', 'integer', 'min:0'],
            'note' => ['nullable', 'string'],
        ]);

        $data['order'] = $data['order'] ?? ($itinerary->items()->max('order') + 1);
        $item = $itinerary->items()->create($data);

        return response()->json($item->load('destination'), 201);
    }

    public function removeItem(Request $request, Itinerary $itinerary, ItineraryItem $item)
    {
        $this->authorizeOwner($request, $itinerary);

        if ($item->itinerary_id !== $itinerary->id) {
            abort(404);
        }

        $item->delete();

        return response()->json(['message' => 'Item removed.']);
    }

    private function authorizeOwner(Request $request, Itinerary $itinerary): void
    {
        if ($itinerary->user_id !== $request->user()->id) {
            abort(403, 'Forbidden.');
        }
    }
}