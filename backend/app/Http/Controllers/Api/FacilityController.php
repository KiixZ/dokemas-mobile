<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Facility;
use Illuminate\Http\Request;

class FacilityController extends Controller
{
    public function index()
    {
        return Facility::orderBy('name')->get();
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'icon' => ['nullable', 'string', 'max:255'],
        ]);

        return response()->json(Facility::create($data), 201);
    }

    public function show(Facility $facility)
    {
        return $facility;
    }

    public function update(Request $request, Facility $facility)
    {
        $data = $request->validate([
            'name' => ['sometimes', 'string', 'max:255'],
            'icon' => ['nullable', 'string', 'max:255'],
        ]);

        $facility->update($data);

        return response()->json($facility);
    }

    public function destroy(Facility $facility)
    {
        $facility->delete();

        return response()->json(['message' => 'Facility deleted.']);
    }
}