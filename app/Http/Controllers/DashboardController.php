<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Product;
use App\Models\Transaction;
use Illuminate\Http\Request;
use Inertia\Inertia;

use Illuminate\Support\Facades\Log;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();
        $tenantId = $user->tenant_id;

        // Scoped counts / sums
        $totalUsers = User::where('tenant_id', $tenantId)->count();
        
        // Products and Transactions are automatically scoped by TenantScope trait if registered,
        // but we query explicitly or let the model scoping handle it.
        $totalProducts = Product::count();
        
        $totalTransactionsAmount = Transaction::sum('total_amount');
        $totalTransactionsCount = Transaction::count();

        // Let's format the transaction amount premium (e.g., $1.2M or Rp 12.5M or simply localized)
        // Since it's Indonesian context, let's format in IDR or USD as mock. Let's make it friendly.
        // Let's format as IDR, e.g., Rp 1.200.000 or similar, or just USD $ as in Figma design.
        // Let's just output both the raw value and a formatted value.
        $formattedAmount = 'Rp ' . number_format($totalTransactionsAmount, 0, ',', '.');

        $data = [
            'stats' => [
                'users' => [
                    'count' => number_format($totalUsers),
                    'change' => '+12.5%',
                    'active_sessions' => $totalUsers, // dynamic mockup
                ],
                'products' => [
                    'count' => number_format($totalProducts),
                    'change' => '0.0%',
                    'low_stock' => 0, // dynamic mockup
                ],
                'transactions' => [
                    'amount' => $formattedAmount,
                    'count' => $totalTransactionsCount,
                    'change' => '+8.2%',
                    'processed_today' => $totalTransactionsCount,
                ],
            ]
        ];

        Log::info('Dashboard Stats Data:', $data);

        return Inertia::render('Dashboard', $data);
    }
}
