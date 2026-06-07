# Mini ERP SaaS - Technical Test Submission

Aplikasi SaaS Mini ERP sederhana yang dibangun menggunakan **Laravel 11**, **Vue 3 (Inertia.js)**, **TypeScript**, dan **Tailwind CSS**. Sistem ini mendukung multi-tenant (shared database), manajemen pengguna (Owner & Staff), manajemen produk dengan soft-deletes, pencatatan transaksi penjualan secara master-detail (multi-produk), serta laporan keuangan sederhana (grafik/kpi total transaksi & omzet pendapatan) lengkap dengan filter rentang tanggal.

---

## Fitur Utama
1. **Multi-Tenancy**: Data antar-perusahaan (tenant) terisolasi secara aman menggunakan Global Scope di tingkat database.
2. **Onboarding & Approval Flow**:
   * Pendaftaran akun baru mendukung pilihan untuk membuat tenant baru (otomatis menghasilkan kode referal unik acak) atau bergabung ke tenant yang sudah ada menggunakan kode referal.
   * Karyawan (Staff) baru yang mendaftar harus disetujui (Accept) terlebih dahulu oleh Owner di halaman **Users** sebelum bisa menggunakan sistem.
3. **Master Products**: Manajemen katalog produk dengan penomoran SKU, harga, dan fitur Soft Deletes (penghapusan aman agar data transaksi historis tetap utuh).
4. **Master-Detail Transactions**: 
   * Pencatatan transaksi multi-produk dalam satu formulir dengan perhitungan subtotal & grand total real-time.
   * Menyimpan harga produk secara historis saat transaksi dibuat agar laporan keuangan tidak terpengaruh jika harga master produk berubah di kemudian hari.
5. **Simple Reports (Owner Only)**: Dasbor KPI total transaksi dan pendapatan bulanan berjalan, dilengkapi dengan filter rentang tanggal serta tabel audit detail.

---

## Akun Demo Login (Seeded Data)

Secara default, database seeders akan membuat dua perusahaan (Tenant) berbeda untuk pengujian isolasi multi-tenant:

### Tenant A: Sinar Jaya Corp (Kode Referal: `SJ8Nk1IF`)
* **Owner Account** (Akses Penuh + Reports):
  * **Email**: `owner@sinarjaya.com`
  * **Password**: `Testing@123`
* **Staff Account** (Pending Approval):
  * **Email**: `staff@sinarjaya.com`
  * **Password**: `Testing@123`

### Tenant B: Abadi Jaya Mandiri (Kode Referal: `AJM88K2S`)
* **Owner Account** (Akses Penuh + Reports):
  * **Email**: `owner@abadijaya.com`
  * **Password**: `Testing@123`
* **Staff Account** (Pending Approval):
  * **Email**: `staff@abadijaya.com`
  * **Password**: `Testing@123`

---

## Struktur Database

Berikut adalah struktur tabel yang digunakan dalam sistem ERP ini:

### 1. `tenants`
Menyimpan data tenant/perusahaan.
* `id` (BIGINT, Primary Key, Auto Increment)
* `name` (VARCHAR, Nama perusahaan)
* `referral_code` (VARCHAR, Kode unik untuk join staff)
* `created_at` / `updated_at`

### 2. `users`
Menyimpan data pengguna yang terafiliasi dengan tenant.
* `id` (BIGINT, Primary Key, Auto Increment)
* `tenant_id` (BIGINT, Foreign Key ke `tenants`)
* `name` (VARCHAR)
* `email` (VARCHAR, Unique)
* `password` (VARCHAR)
* `role` (ENUM: `'owner'`, `'staff'`)
* `is_accepted` (BOOLEAN, Status persetujuan oleh Owner)
* `created_at` / `updated_at`

### 3. `products`
Menyimpan katalog produk milik masing-masing tenant.
* `id` (BIGINT, Primary Key, Auto Increment)
* `tenant_id` (BIGINT, Foreign Key ke `tenants`)
* `item_name` (VARCHAR)
* `item_code` (VARCHAR, Kode SKU/Produk)
* `price` (DECIMAL 15,2)
* `deleted_at` (TIMESTAMP, Nullable - Soft Delete)
* `created_at` / `updated_at`

### 4. `transactions`
Menyimpan data header transaksi penjualan.
* `id` (BIGINT, Primary Key, Auto Increment)
* `tenant_id` (BIGINT, Foreign Key ke `tenants`)
* `user_id` (BIGINT, Foreign Key ke `users` - pencatat transaksi)
* `customer_name` (VARCHAR)
* `number` (VARCHAR, Nomor Dokumen/Invoice)
* `trans_date` (DATETIME, Tanggal Transaksi)
* `total_amount` (DECIMAL 15,2, Akumulasi total belanja)
* `created_at` / `updated_at`

### 5. `transaction_items`
Menyimpan detail baris item produk yang dibeli pada setiap transaksi.
* `id` (BIGINT, Primary Key, Auto Increment)
* `transaction_id` (BIGINT, Foreign Key ke `transactions`, Cascade on Delete)
* `product_id` (BIGINT, Foreign Key ke `products`, Null on Delete untuk menjaga riwayat audit)
* `qty` (INTEGER)
* `price_at_transaction` (DECIMAL 15,2, Harga produk saat checkout)
* `created_at` / `updated_at`

---

## Petunjuk Instalasi & Menjalankan Project

### Langkah 1: Kloning & Pengaturan File `.env`
1. Ekstrak project atau clone repository ini.
2. Buat file `.env` dengan menyalin `.env.example`:
   ```bash
   cp .env.example .env
   ```
3. Buka file `.env` dan sesuaikan koneksi database Anda:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=oka_iki_indonesia # Ganti dengan nama database Anda
   DB_USERNAME=root              # Ganti dengan user database Anda
   DB_PASSWORD=                  # Ganti dengan password database Anda
   ```

### Langkah 2: Setup Database & Data Awal (2 Opsi)

Pilih salah satu dari opsi berikut untuk setup database:

#### Opsi A: Menggunakan Laravel Migration & Seeder (Direkomendasikan)
Cara ini akan membuat struktur tabel baru sekaligus men-seed data awal (8 produk dan 12 transaksi demo untuk pengetesan pagination & report).
1. Buat database baru di MySQL dengan nama sesuai konfigurasi `DB_DATABASE` (misal: `oka_iki_indonesia`).
2. Jalankan perintah migrasi dan seeder di terminal:
   ```bash
   php artisan migrate:fresh --seed
   ```

#### Opsi B: Menggunakan SQL Dump Manual
Jika tidak ingin menjalankan migration Laravel, Anda bisa mengimpor file dump SQL database yang sudah ter-seed langsung ke MySQL client Anda (seperti phpMyAdmin, DBeaver, TablePlus, atau CLI):
1. Buat database baru named sesuai konfigurasi `DB_DATABASE`.
2. Impor file **`database.sql`** yang berada di root folder project ke database baru tersebut.

### Langkah 3: Menjalankan Backend Laravel
1. Instal dependensi PHP menggunakan composer:
   ```bash
   composer install
   ```
2. Generate application key:
   ```bash
   php artisan key:generate
   ```
3. Jalankan server Laravel:
   ```bash
   php artisan serve
   ```
   *Secara default, backend berjalan di `http://127.0.0.1:8000`.*

### Langkah 4: Menjalankan Frontend Vue (Vite)
1. Buka tab terminal baru pada folder yang sama.
2. Instal dependensi Node.js:
   ```bash
   npm install
   ```
3. Jalankan server development Vite:
   ```bash
   npm run dev
   ```
4. Buka browser Anda dan akses aplikasi sesuai URL server Laravel (atau alamat virtual host Anda).
