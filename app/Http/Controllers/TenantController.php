<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Tenant;
use App\Models\User;
use Inertia\Inertia;

class TenantController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();
        $tenant = Tenant::findOrFail($user->tenant_id);

        $owner = User::where('tenant_id', $tenant->id)
            ->where('role', 'owner')
            ->first();

        return Inertia::render('Tenant', [
            'tenant' => $tenant,
            'owner' => $owner,
        ]);
    }
}
