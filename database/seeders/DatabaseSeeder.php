<?php

namespace Database\Seeders;

use App\Models\User;
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
        $tenantA = \App\Models\Tenant::create([
            'name' => 'Sinar Jaya Corp',
            'referral_code' => 'SJ8Nk1IF'
        ]);

        $ownerA = User::create([
            'tenant_id' => $tenantA->id,
            'name' => 'Budi',
            'email' => 'owner@sinarjaya.com',
            'password' => bcrypt('password'),
            'role' => 'owner',
        ]);

        $staffA = User::create([
            'tenant_id' => $tenantA->id,
            'name' => 'Andi',
            'email' => 'staff@sinarjaya.com',
            'password' => bcrypt('password'),
            'role' => 'staff',
        ]);

        // Tenant B
        $tenantB = \App\Models\Tenant::create([
            'name' => 'Abadi Jaya Mandiri',
            'referral_code' => 'AJM88K2S'
        ]);

        $ownerB = User::create([
            'tenant_id' => $tenantB->id,
            'name' => 'Siti',
            'email' => 'owner@abadijaya.com',
            'password' => bcrypt('password'),
            'role' => 'owner',
        ]);

        $staffB = User::create([
            'tenant_id' => $tenantB->id,
            'name' => 'Joko',
            'email' => 'staff@abadijaya.com',
            'password' => bcrypt('password'),
            'role' => 'staff',
        ]);
    }
}
