<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;
use Inertia\Inertia;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');

        $products = Product::query()
            ->when($search, function ($query, $search) {
                $query->where(function ($q) use ($search) {
                    $q->where('item_name', 'like', "%{$search}%")
                      ->orWhere('item_code', 'like', "%{$search}%");
                });
            })
            ->orderBy('item_name')
            ->paginate(5)
            ->withQueryString();

        return Inertia::render('Products', [
            'products' => $products,
            'filters' => [
                'search' => $search
            ]
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'item_name' => ['required', 'string', 'max:255'],
            'item_code' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', 'min:0'],
        ]);

        Product::create([
            'tenant_id' => auth()->user()->tenant_id,
            'item_name' => $validated['item_name'],
            'item_code' => $validated['item_code'],
            'price' => $validated['price'],
        ]);

        return redirect()->back()->with('status', 'Product created successfully.');
    }

    public function update(Request $request, Product $product)
    {
        // Enforce same-tenant constraint
        if ($product->tenant_id !== auth()->user()->tenant_id) {
            abort(403, 'Unauthorized.');
        }

        $validated = $request->validate([
            'item_name' => ['required', 'string', 'max:255'],
            'item_code' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', 'min:0'],
        ]);

        $product->update($validated);

        return redirect()->back()->with('status', 'Product updated successfully.');
    }

    public function destroy(Product $product)
    {
        // Enforce same-tenant constraint
        if ($product->tenant_id !== auth()->user()->tenant_id) {
            abort(403, 'Unauthorized.');
        }

        $product->delete(); // Automatically triggers Soft Delete

        return redirect()->back()->with('status', 'Product deleted successfully.');
    }
}
