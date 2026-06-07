<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use App\Models\Product;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');

        $transactions = Transaction::query()
            ->with(['user', 'items.product'])
            ->when($search, function ($query, $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('customer_name', 'like', "%{$search}%")
                      ->orWhere('number', 'like', "%{$search}%");
                });
            })
            ->orderBy('created_at', 'desc')
            ->paginate(5)
            ->withQueryString();

        $products = Product::orderBy('item_name')->get();

        return Inertia::render('Transactions', [
            'transactions' => $transactions,
            'products' => $products,
            'filters' => [
                'search' => $search
            ]
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'customer_name' => ['required', 'string', 'max:255'],
            'number' => ['required', 'string', 'max:255'],
            'trans_date' => ['required', 'date'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => ['required', 'exists:products,id'],
            'items.*.qty' => ['required', 'integer', 'min:1'],
            'items.*.price_at_transaction' => ['required', 'numeric', 'min:0'],
        ]);

        DB::transaction(function () use ($validated) {
            $totalAmount = 0;
            foreach ($validated['items'] as $item) {
                $totalAmount += $item['qty'] * $item['price_at_transaction'];
            }

            $transaction = Transaction::create([
                'tenant_id' => auth()->user()->tenant_id,
                'user_id' => auth()->id(),
                'customer_name' => $validated['customer_name'],
                'number' => $validated['number'],
                'trans_date' => $validated['trans_date'],
                'total_amount' => $totalAmount,
            ]);

            foreach ($validated['items'] as $item) {
                $transaction->items()->create([
                    'product_id' => $item['product_id'],
                    'qty' => $item['qty'],
                    'price_at_transaction' => $item['price_at_transaction'],
                ]);
            }
        });

        return redirect()->back()->with('status', 'Transaction created successfully.');
    }

    public function update(Request $request, Transaction $transaction)
    {
        if ($transaction->tenant_id !== auth()->user()->tenant_id) {
            abort(403, 'Unauthorized.');
        }

        $validated = $request->validate([
            'customer_name' => ['required', 'string', 'max:255'],
            'number' => ['required', 'string', 'max:255'],
            'trans_date' => ['required', 'date'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => ['required', 'exists:products,id'],
            'items.*.qty' => ['required', 'integer', 'min:1'],
            'items.*.price_at_transaction' => ['required', 'numeric', 'min:0'],
        ]);

        DB::transaction(function () use ($transaction, $validated) {
            $totalAmount = 0;
            foreach ($validated['items'] as $item) {
                $totalAmount += $item['qty'] * $item['price_at_transaction'];
            }

            $transaction->update([
                'customer_name' => $validated['customer_name'],
                'number' => $validated['number'],
                'trans_date' => $validated['trans_date'],
                'total_amount' => $totalAmount,
            ]);

            // Delete old items and insert updated ones
            $transaction->items()->delete();

            foreach ($validated['items'] as $item) {
                $transaction->items()->create([
                    'product_id' => $item['product_id'],
                    'qty' => $item['qty'],
                    'price_at_transaction' => $item['price_at_transaction'],
                ]);
            }
        });

        return redirect()->back()->with('status', 'Transaction updated successfully.');
    }

    public function destroy(Transaction $transaction)
    {
        if ($transaction->tenant_id !== auth()->user()->tenant_id) {
            abort(403, 'Unauthorized.');
        }

        $transaction->delete();

        return redirect()->back()->with('status', 'Transaction deleted successfully.');
    }
}
