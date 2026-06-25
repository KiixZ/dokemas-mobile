<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Destination;
use App\Models\DestinationImage;
use App\Services\ImageService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class DestinationController extends Controller
{
    public function __construct(private ImageService $images) {}

    public function index(Request $request)
    {
        $query = Destination::query()->with(['category', 'images'])->withCount('reviews');

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('address', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        if ($categoryId = $request->query('category_id')) {
            $query->where('category_id', $categoryId);
        }

        if (! is_null($request->query('min_price'))) {
            $query->where('price', '>=', (float) $request->query('min_price'));
        }
        if (! is_null($request->query('max_price'))) {
            $query->where('price', '<=', (float) $request->query('max_price'));
        }

        if ($request->boolean('popular')) {
            $query->where('is_popular', true);
        }

        $sort = $request->query('sort', 'latest');
        match ($sort) {
            'rating' => $query->orderByDesc('rating_avg'),
            'price_asc' => $query->orderBy('price'),
            'price_desc' => $query->orderByDesc('price'),
            'name' => $query->orderBy('name'),
            default => $query->latest(),
        };

        return $query->paginate($request->integer('per_page', 15));
    }

    public function store(Request $request)
    {
        $data = $this->validateData($request);
        unset($data['thumbnail'], $data['images']);
        $data['slug'] = Str::slug($data['name']).'-'.Str::random(5);

        if ($request->hasFile('thumbnail')) {
            $data['thumbnail'] = $this->images->storeAsWebp($request->file('thumbnail'), 'destinations');
        }

        $facilities = $request->input('facility_ids', []);
        $destination = Destination::create($data);

        $this->storeGallery($request, $destination);
        if ($facilities) {
            $destination->facilities()->sync($facilities);
        }

        return response()->json($destination->load(['category', 'facilities', 'images']), 201);
    }

    public function show(Destination $destination)
    {
        return $destination->load([
            'category',
            'facilities',
            'images',
            'reviews.user:id,name,avatar',
        ]);
    }

    public function update(Request $request, Destination $destination)
    {
        $data = $this->validateData($request, false);
        unset($data['thumbnail'], $data['images']);
        if (isset($data['name'])) {
            $data['slug'] = Str::slug($data['name']).'-'.Str::random(5);
        }

        if ($request->hasFile('thumbnail')) {
            $this->images->delete($destination->thumbnail);
            $data['thumbnail'] = $this->images->storeAsWebp($request->file('thumbnail'), 'destinations');
        }

        $destination->update($data);
        $this->storeGallery($request, $destination);
        if ($request->has('facility_ids')) {
            $destination->facilities()->sync($request->input('facility_ids', []));
        }

        return response()->json($destination->load(['category', 'facilities', 'images']));
    }

    public function destroy(Destination $destination)
    {
        // hapus file fisik thumbnail + galeri
        $this->images->delete($destination->thumbnail);
        foreach ($destination->images as $image) {
            $this->images->delete($image->image_path);
        }

        $destination->delete();

        return response()->json(['message' => 'Destination deleted.']);
    }

    /**
     * Upload satu/banyak foto galeri (field: images[] atau image).
     */
    public function uploadImages(Request $request, Destination $destination)
    {
        $request->validate([
            'images' => ['required_without:image', 'array'],
            'images.*' => ['image', 'mimes:jpg,jpeg,png,webp', 'max:5120'],
            'image' => ['required_without:images', 'image', 'mimes:jpg,jpeg,png,webp', 'max:5120'],
            'caption' => ['nullable', 'string', 'max:255'],
        ]);

        $files = $request->file('images', []);
        if ($request->hasFile('image')) {
            $files[] = $request->file('image');
        }

        $created = [];
        foreach ($files as $file) {
            $path = $this->images->storeAsWebp($file, 'destinations');
            $created[] = $destination->images()->create([
                'image_path' => $path,
                'caption' => $request->input('caption'),
            ]);
        }

        return response()->json($created, 201);
    }

    public function deleteImage(DestinationImage $image)
    {
        $this->images->delete($image->image_path);
        $image->delete();

        return response()->json(['message' => 'Image deleted.']);
    }

    private function storeGallery(Request $request, Destination $destination): void
    {
        foreach ($request->file('images', []) as $file) {
            $path = $this->images->storeAsWebp($file, 'destinations');
            $destination->images()->create(['image_path' => $path]);
        }
    }

    private function validateData(Request $request, bool $creating = true): array
    {
        $required = $creating ? 'required' : 'sometimes';

        return $request->validate([
            'category_id' => [$required, 'exists:categories,id'],
            'name' => [$required, 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'address' => ['nullable', 'string', 'max:255'],
            'latitude' => ['nullable', 'numeric'],
            'longitude' => ['nullable', 'numeric'],
            'price' => ['nullable', 'numeric', 'min:0'],
            'opening_hours' => ['nullable', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:30'],
            'thumbnail' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:5120'],
            'is_popular' => ['nullable', 'boolean'],
            'facility_ids' => ['nullable', 'array'],
            'facility_ids.*' => ['integer', 'exists:facilities,id'],
            'images' => ['nullable', 'array'],
            'images.*' => ['image', 'mimes:jpg,jpeg,png,webp', 'max:5120'],
        ]);
    }
}