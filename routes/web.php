<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\UserController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\TenantController;

Route::redirect('/', '/dashboard')->name('home');

Route::middleware(['auth'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // User Routes
    Route::get('/users', [UserController::class, 'index'])->name('users');
    Route::patch('/users/{user}/accept', [UserController::class, 'accept'])->name('users.accept')->middleware('role:owner');

    // Tenant Routes
    Route::get('/tenants', [TenantController::class, 'index'])->name('tenants');
});

require __DIR__.'/settings.php';
