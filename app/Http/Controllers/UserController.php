<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Inertia\Inertia;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $tenantId = auth()->user()->tenant_id;

        $activeUsers = User::where('tenant_id', $tenantId)
            ->where('is_accepted', true)
            ->orderBy('name')
            ->get();

        $pendingUsers = User::where('tenant_id', $tenantId)
            ->where('is_accepted', false)
            ->orderBy('name')
            ->get();

        return Inertia::render('Users', [
            'activeUsers' => $activeUsers,
            'pendingUsers' => $pendingUsers,
        ]);
    }

    public function accept(User $user)
    {
        $user->update(['is_accepted' => true]);
        return redirect()->back()->with('status', 'User accepted successfully.');
    }
}
