<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Tenant;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Tenant A
        $tenantA = Tenant::create([
            'name' => 'Sinar Jaya Corp',
            'referral_code' => 'SJ8Nk1IF'
        ]);

        $ownerA = User::create([
            'tenant_id' => $tenantA->id,
            'name' => 'Budi',
            'email' => 'owner@sinarjaya.com',
            'password' => bcrypt('Testing@123'),
            'role' => 'owner',
            'is_accepted' => true,
        ]);

        $staffA = User::create([
            'tenant_id' => $tenantA->id,
            'name' => 'Andi',
            'email' => 'staff@sinarjaya.com',
            'password' => bcrypt('Testing@123'),
            'role' => 'staff',
            'is_accepted' => false,
        ]);

        // Tenant B
        $tenantB = Tenant::create([
            'name' => 'Abadi Jaya Mandiri',
            'referral_code' => 'AJM88K2S'
        ]);

        $ownerB = User::create([
            'tenant_id' => $tenantB->id,
            'name' => 'Siti',
            'email' => 'owner@abadijaya.com',
            'password' => bcrypt('Testing@123'),
            'role' => 'owner',
            'is_accepted' => true,
        ]);

        $staffB = User::create([
            'tenant_id' => $tenantB->id,
            'name' => 'Joko',
            'email' => 'staff@abadijaya.com',
            'password' => bcrypt('Testing@123'),
            'role' => 'staff',
            'is_accepted' => false,
        ]);

        // Seed Products for Tenant A
        $productsA = [];
        $productNamesA = ['Coffee Beans', 'Tea Leaves', 'Brown Sugar', 'Fresh Milk', 'Vanilla Syrup', 'Cocoa Powder', 'Caramel Sauce', 'Paper Cups'];
        foreach ($productNamesA as $index => $name) {
            $productsA[] = Product::create([
                'tenant_id' => $tenantA->id,
                'item_name' => $name,
                'item_code' => 'PROD-A' . str_pad($index + 1, 3, '0', STR_PAD_LEFT),
                'price' => 15000 + ($index * 5000),
            ]);
        }

        // Seed Transactions for Tenant A (12 transactions to test pagination)
        for ($i = 1; $i <= 12; $i++) {
            $trans = Transaction::create([
                'tenant_id' => $tenantA->id,
                'user_id' => $ownerA->id,
                'customer_name' => 'Customer ' . chr(64 + $i), // Customer A, B, C...
                'number' => 'TX-A-' . str_pad($i, 4, '0', STR_PAD_LEFT),
                'trans_date' => now()->subDays(12 - $i)->format('Y-m-d H:i:s'),
                'total_amount' => 0, // Will update after calculation
            ]);

            $totalAmount = 0;
            // Add 1 to 3 random products
            $itemsCount = rand(1, 3);
            $shuffledKeys = array_rand($productsA, $itemsCount);
            $selectedKeys = is_array($shuffledKeys) ? $shuffledKeys : [$shuffledKeys];

            foreach ($selectedKeys as $key) {
                $product = $productsA[$key];
                $qty = rand(1, 4);
                $price = $product->price;
                $totalAmount += $qty * $price;

                $trans->items()->create([
                    'product_id' => $product->id,
                    'qty' => $qty,
                    'price_at_transaction' => $price,
                ]);
            }

            $trans->update(['total_amount' => $totalAmount]);
        }

        // Seed Products for Tenant B
        $productsB = [];
        $productNamesB = ['Laptop Acer', 'Mouse Logitech', 'Keyboard Mechanical', 'Monitor Dell 24', 'USB Flashdrive 64GB', 'HDMI Cable 2M'];
        foreach ($productNamesB as $index => $name) {
            $productsB[] = Product::create([
                'tenant_id' => $tenantB->id,
                'item_name' => $name,
                'item_code' => 'PROD-B' . str_pad($index + 1, 3, '0', STR_PAD_LEFT),
                'price' => 50000 + ($index * 150000),
            ]);
        }

        // Seed Transactions for Tenant B
        for ($i = 1; $i <= 5; $i++) {
            $trans = Transaction::create([
                'tenant_id' => $tenantB->id,
                'user_id' => $ownerB->id,
                'customer_name' => 'Client ' . chr(79 + $i),
                'number' => 'TX-B-' . str_pad($i, 4, '0', STR_PAD_LEFT),
                'trans_date' => now()->subDays(5 - $i)->format('Y-m-d H:i:s'),
                'total_amount' => 0,
            ]);

            $totalAmount = 0;
            $itemsCount = rand(1, 2);
            $shuffledKeys = array_rand($productsB, $itemsCount);
            $selectedKeys = is_array($shuffledKeys) ? $shuffledKeys : [$shuffledKeys];

            foreach ($selectedKeys as $key) {
                $product = $productsB[$key];
                $qty = rand(1, 2);
                $price = $product->price;
                $totalAmount += $qty * $price;

                $trans->items()->create([
                    'product_id' => $product->id,
                    'qty' => $qty,
                    'price_at_transaction' => $price,
                ]);
            }

            $trans->update(['total_amount' => $totalAmount]);
        }
    }
}
