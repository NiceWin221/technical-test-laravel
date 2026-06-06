<script setup lang="ts">
import { Head, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';
import { dashboard } from '@/routes';
import { Users, Package, CreditCard, TrendingUp, Sparkles } from '@lucide/vue';

// Define layout option so breadcrumbs show correctly in the sidebar header
defineOptions({
    layout: {
        breadcrumbs: [
            {
                title: 'Dashboard',
                href: dashboard(),
            },
        ],
    },
});

interface DashboardStats {
    users: { count: string; change: string; active_sessions: number };
    products: { count: string; change: string; low_stock: number };
    transactions: { amount: string; count: number; change: string; processed_today: number };
}

const page = usePage();
const user = computed(() => page.props.auth.user);
const stats = computed<DashboardStats>(() => (page.props.stats as any) || {
    users: { count: '0', change: '+0%', active_sessions: 0 },
    products: { count: '0', change: '0.0%', low_stock: 0 },
    transactions: { amount: 'Rp 0', count: 0, change: '+0%', processed_today: 0 }
});
</script>

<template>
    <Head title="Dashboard" />

    <div class="flex flex-1 flex-col gap-6 p-6 bg-slate-50/50 dark:bg-zinc-950/20 min-h-screen">
        <!-- Welcome Header -->
        <div class="flex flex-col gap-1">
            <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                Welcome Back, {{ user?.name || 'Admin' }}
            </h1>
            <p class="text-sm text-slate-500 dark:text-slate-400">
                Here's what's happening with your enterprise resources today.
            </p>
        </div>

        <!-- Section - Stats Grid -->
        <div class="grid gap-6 md:grid-cols-3">
            <!-- Total Users Card -->
            <div class="relative overflow-hidden rounded-xl border border-slate-200/80 bg-white p-6 shadow-sm transition-all duration-300 hover:shadow-md dark:border-zinc-800 dark:bg-zinc-900">
                <div class="flex items-center justify-between">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-50 text-blue-600 dark:bg-blue-950/50 dark:text-blue-400">
                        <Users class="h-5 w-5" />
                    </div>
                    <div class="flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-0.5 text-xs font-medium text-emerald-600 dark:bg-emerald-950/30 dark:text-emerald-400">
                        <TrendingUp class="h-3 w-3" />
                        {{ stats.users.change }}
                    </div>
                </div>
                <div class="mt-4">
                    <p class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">
                        Total Users
                    </p>
                    <h3 class="mt-1 text-3xl font-bold tracking-tight text-slate-950 dark:text-white">
                        {{ stats.users.count }}
                    </h3>
                </div>
                <div class="mt-4 border-t border-slate-100 pt-4 dark:border-zinc-800">
                    <p class="text-xs text-slate-500 dark:text-zinc-400">
                        Active sessions: <span class="font-semibold text-slate-900 dark:text-white">{{ stats.users.active_sessions }}</span>
                    </p>
                </div>
            </div>

            <!-- Total Products Card -->
            <div class="relative overflow-hidden rounded-xl border border-slate-200/80 bg-white p-6 shadow-sm transition-all duration-300 hover:shadow-md dark:border-zinc-800 dark:bg-zinc-900">
                <div class="flex items-center justify-between">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-amber-50 text-amber-600 dark:bg-amber-950/50 dark:text-amber-400">
                        <Package class="h-5 w-5" />
                    </div>
                    <div class="flex items-center gap-1 rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-600 dark:bg-zinc-800 dark:text-zinc-400">
                        {{ stats.products.change }}
                    </div>
                </div>
                <div class="mt-4">
                    <p class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">
                        Total Products
                    </p>
                    <h3 class="mt-1 text-3xl font-bold tracking-tight text-slate-950 dark:text-white">
                        {{ stats.products.count }}
                    </h3>
                </div>
                <div class="mt-4 border-t border-slate-100 pt-4 dark:border-zinc-800">
                    <p class="text-xs text-slate-500 dark:text-zinc-400">
                        Low stock alerts: <span class="font-semibold text-slate-900 dark:text-white">{{ stats.products.low_stock }}</span>
                    </p>
                </div>
            </div>

            <!-- Total Transactions Card -->
            <div class="relative overflow-hidden rounded-xl border border-slate-200/80 bg-white p-6 shadow-sm transition-all duration-300 hover:shadow-md dark:border-zinc-800 dark:bg-zinc-900">
                <div class="flex items-center justify-between">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-50 text-emerald-600 dark:bg-emerald-950/50 dark:text-emerald-400">
                        <CreditCard class="h-5 w-5" />
                    </div>
                    <div class="flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-0.5 text-xs font-medium text-emerald-600 dark:bg-emerald-950/30 dark:text-emerald-400">
                        <TrendingUp class="h-3 w-3" />
                        {{ stats.transactions.change }}
                    </div>
                </div>
                <div class="mt-4">
                    <p class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">
                        Total Transactions
                    </p>
                    <h3 class="mt-1 text-3xl font-bold tracking-tight text-slate-950 dark:text-white">
                        {{ stats.transactions.amount }}
                    </h3>
                </div>
                <div class="mt-4 border-t border-slate-100 pt-4 dark:border-zinc-800">
                    <p class="text-xs text-slate-500 dark:text-zinc-400">
                        Processed today: <span class="font-semibold text-slate-900 dark:text-white">{{ stats.transactions.processed_today }}</span>
                    </p>
                </div>
            </div>
        </div>

        <!-- Section - Coming Soon / Custom Content -->
        <div class="relative flex flex-col items-center justify-center rounded-xl border border-dashed border-slate-300 bg-white p-12 text-center shadow-sm dark:border-zinc-800 dark:bg-zinc-900/50 min-h-[300px]">
            <div class="flex h-12 w-12 items-center justify-center rounded-full bg-indigo-50 text-indigo-600 dark:bg-indigo-950/50 dark:text-indigo-400">
                <Sparkles class="h-6 w-6 animate-pulse" />
            </div>
            <h3 class="mt-4 text-lg font-semibold text-slate-900 dark:text-slate-100">
                Recent System Events
            </h3>
            <p class="mt-2 text-sm text-slate-500 dark:text-slate-400 max-w-sm">
                This section is coming soon. A live log of all critical enterprise transactions and user actions will be displayed here.
            </p>
        </div>
    </div>
</template>
