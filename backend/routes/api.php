<?php

use App\Http\Controllers\Api\Admin\DashboardController;
use App\Http\Controllers\Api\Admin\UserController as AdminUserController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\DestinationController;
use App\Http\Controllers\Api\FacilityController;
use App\Http\Controllers\Api\ItineraryController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\WishlistController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Public routes (guest)
|--------------------------------------------------------------------------
*/
Route::get('register', function () {
    return response()->json(['message' => 'Method GET not allowed. Use POST to register.'], 405);
});
Route::post('register', [AuthController::class, 'register']);
Route::get('login', function () {
    return response()->json(['message' => 'Unauthenticated.'], 401);
})->name('login');
Route::post('login', [AuthController::class, 'login']);

Route::get('categories', [CategoryController::class, 'index']);
Route::get('categories/{category}', [CategoryController::class, 'show']);
Route::get('facilities', [FacilityController::class, 'index']);
Route::get('destinations', [DestinationController::class, 'index']);
Route::get('destinations/{destination}', [DestinationController::class, 'show']);
Route::get('destinations/{destination}/reviews', [ReviewController::class, 'index']);

/*
|--------------------------------------------------------------------------
| Authenticated routes (user)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {
    // Account
    Route::get('me', [AuthController::class, 'me']);
    Route::post('logout', [AuthController::class, 'logout']);
    Route::put('profile', [AuthController::class, 'updateProfile']);
    // upload avatar (multipart -> pakai POST; field: avatar)
    Route::post('profile/avatar', [AuthController::class, 'updateProfile']);

    // Reviews
    Route::post('destinations/{destination}/reviews', [ReviewController::class, 'store']);
    Route::put('reviews/{review}', [ReviewController::class, 'update']);
    Route::delete('reviews/{review}', [ReviewController::class, 'destroy']);

    // Wishlist
    Route::get('wishlist', [WishlistController::class, 'index']);
    Route::post('wishlist', [WishlistController::class, 'store']);
    Route::post('wishlist/toggle', [WishlistController::class, 'toggle']);
    Route::delete('wishlist/{destination}', [WishlistController::class, 'destroy']);

    // Itineraries
    Route::apiResource('itineraries', ItineraryController::class);
    Route::post('itineraries/{itinerary}/items', [ItineraryController::class, 'addItem']);
    Route::delete('itineraries/{itinerary}/items/{item}', [ItineraryController::class, 'removeItem']);

    /*
    |----------------------------------------------------------------------
    | Admin routes
    |----------------------------------------------------------------------
    */
    Route::middleware('admin')->prefix('admin')->group(function () {
        Route::get('/', function () {
            return response()->json(['message' => 'DOKEMAS Admin API Base Route']);
        });
        Route::get('dashboard', DashboardController::class);

        Route::apiResource('categories', CategoryController::class)->except(['index', 'show']);
        Route::apiResource('facilities', FacilityController::class)->except(['index']);
        Route::apiResource('destinations', DestinationController::class)->except(['index', 'show']);
        Route::apiResource('users', AdminUserController::class);

        // Galeri foto destinasi (upload auto-convert ke WebP)
        Route::post('destinations/{destination}/images', [DestinationController::class, 'uploadImages']);
        Route::delete('destination-images/{image}', [DestinationController::class, 'deleteImage']);
    });
});