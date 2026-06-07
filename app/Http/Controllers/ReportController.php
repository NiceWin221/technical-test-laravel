<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use Inertia\Inertia;
use Illuminate\Support\Carbon;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $startDate = $request->input('start_date');
        $endDate = $request->input('end_date');

        // Default to current month's start and end dates
        if (empty($startDate)) {
            $startDate = Carbon::now()->startOfMonth()->toDateString();
        }
        if (empty($endDate)) {
            $endDate = Carbon::now()->endOfMonth()->toDateString();
        }

        // Set hours to cover the entire day for queries
        $queryStart = Carbon::parse($startDate)->startOfDay()->toDateTimeString();
        $queryEnd = Carbon::parse($endDate)->endOfDay()->toDateTimeString();

        // Query transactions within range (scoped automatically by tenant via global scope)
        $transactionsQuery = Transaction::query()
            ->with(['user'])
            ->whereBetween('trans_date', [$queryStart, $queryEnd])
            ->orderBy('trans_date', 'desc');

        // Metrics aggregation
        $totalTransactionsCount = $transactionsQuery->count();
        $totalRevenueSum = $transactionsQuery->sum('total_amount');

        // Get the list of matching transactions
        $transactions = $transactionsQuery->get();

        return Inertia::render('Reports', [
            'totalTransactions' => $totalTransactionsCount,
            'totalRevenue' => (float) $totalRevenueSum,
            'transactions' => $transactions,
            'filters' => [
                'start_date' => $startDate,
                'end_date' => $endDate,
            ]
        ]);
    }
}
