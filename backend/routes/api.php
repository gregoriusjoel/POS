<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\MenuController;
use App\Http\Controllers\TransaksiController;
use App\Http\Controllers\DashboardController;
use Illuminate\Support\Facades\Route;

// Route public
Route::post('/login', [AuthController::class, 'login']);

// Route yang butuh autentikasi Sanctum
Route::middleware('auth:sanctum')->group(function () {

    // Logout
    Route::post('/logout', [AuthController::class, 'logout']);

    // Group route menu dengan prefix /menus
    Route::prefix('menus')->group(function () {
        Route::get('/', [MenuController::class, 'index']);       // GET /menus
        Route::post('/', [MenuController::class, 'store']);      // POST /menus
        Route::get('/{id}', [MenuController::class, 'show']);    // GET /menus/{id}
        Route::put('/{id}', [MenuController::class, 'update']);  // PUT /menus/{id}
        Route::delete('/{id}', [MenuController::class, 'destroy']); // DELETE /menus/{id}

        // Contoh custom route tambahan, misal untuk cari menu by category
        Route::get('/category/{category}', [MenuController::class, 'getByCategory']); // GET /menus/category/{category}
    });

    // Group route transaksi dengan prefix /transaksis
    Route::prefix('transaksis')->group(function () {
        Route::get('/', [TransaksiController::class, 'index']);
        Route::post('/', [TransaksiController::class, 'store']);
        Route::get('/{id}', [TransaksiController::class, 'show']);
        Route::put('/{id}', [TransaksiController::class, 'update']);
        Route::delete('/{id}', [TransaksiController::class, 'destroy']);

        // Contoh custom route: get transaksi by user
        Route::get('/user/{userId}', [TransaksiController::class, 'getByUser']);
    });

    // Route dashboard summary
    Route::get('dashboard/summary', [DashboardController::class, 'summary']);
});
