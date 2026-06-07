<script setup lang="ts">
import { Head, usePage, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { BarChart3, Calendar, FileText, ArrowLeft, ArrowRight, DollarSign, TrendingUp } from '@lucide/vue';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Button } from '@/components/ui/button';

// Define layout option so breadcrumbs show correctly in the sidebar header
defineOptions({
    layout: {
        breadcrumbs: [
            {
                title: 'Reports',
                href: '/reports',
            },
        ],
    },
});

interface Transaction {
    id: number;
    customer_name: string;
    number: string;
    trans_date: string;
    total_amount: number;
    user?: {
        name: string;
    };
}

const props = defineProps<{
    totalTransactions: number;
    totalRevenue: number;
    transactions: Transaction[];
    filters: {
        start_date: string;
        end_date: string;
    };
}>();

const page = usePage();
const currentUser = computed(() => page.props.auth.user);

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');

const handleFilter = () => {
    router.get('/reports', {
        start_date: startDate.value,
        end_date: endDate.value
    }, {
        preserveState: true,
        preserveScroll: true
    });
};

const handleReset = () => {
    startDate.value = '';
    endDate.value = '';
    router.get('/reports', {}, {
        preserveState: true,
        preserveScroll: true
    });
};

const formatPrice = (price: number | string) => {
    const num = typeof price === 'string' ? parseFloat(price) : price;
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(num);
};

const formatDate = (dateStr: string) => {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    return date.toLocaleDateString('id-ID', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};
</script>

<template>
    <Head title="Financial Reports" />

    <div class="flex flex-1 flex-col gap-6 p-6 bg-slate-50/50 dark:bg-zinc-950/20 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col gap-1">
            <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100 flex items-center gap-2">
                <BarChart3 class="h-6 w-6 text-blue-600 dark:text-blue-500" />
                Financial Reports
            </h1>
            <p class="text-sm text-slate-500 dark:text-slate-400">
                Track and monitor your business total sales volume and revenue performance.
            </p>
        </div>

        <!-- Date Range Filter Form -->
        <div class="rounded-xl border border-slate-200/80 bg-white p-5 shadow-xs dark:border-zinc-800 dark:bg-zinc-900">
            <form @submit.prevent="handleFilter" class="flex flex-col md:flex-row items-end gap-4">
                <div class="grid gap-1.5 w-full md:w-auto md:flex-1">
                    <Label for="start_date">Start Date</Label>
                    <div class="relative">
                        <Calendar class="absolute left-3 top-2.5 h-4 w-4 text-slate-400 dark:text-zinc-500" />
                        <Input id="start_date" type="date" v-model="startDate" class="pl-9 h-9" required />
                    </div>
                </div>
                <div class="grid gap-1.5 w-full md:w-auto md:flex-1">
                    <Label for="end_date">End Date</Label>
                    <div class="relative">
                        <Calendar class="absolute left-3 top-2.5 h-4 w-4 text-slate-400 dark:text-zinc-500" />
                        <Input id="end_date" type="date" v-model="endDate" class="pl-9 h-9" required />
                    </div>
                </div>
                <div class="flex gap-2 w-full md:w-auto">
                    <Button type="submit" class="flex-1 md:flex-initial bg-blue-600 hover:bg-blue-700 text-white font-semibold h-9 cursor-pointer">
                        Filter Report
                    </Button>
                    <Button type="button" @click="handleReset" variant="outline" class="flex-1 md:flex-initial h-9 cursor-pointer">
                        Reset
                    </Button>
                </div>
            </form>
        </div>

        <!-- Metrics Dashboard Widgets -->
        <div class="grid gap-6 md:grid-cols-2">
            <!-- Total Transactions widget -->
            <div class="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white p-6 shadow-sm dark:border-zinc-800 dark:bg-zinc-900 transition-all hover:shadow-md">
                <div class="flex items-center justify-between">
                    <div class="space-y-2">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Total Transactions</span>
                        <div class="text-3xl font-black text-slate-900 dark:text-white">{{ totalTransactions }}</div>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
                        <FileText class="h-6 w-6" />
                    </div>
                </div>
                <div class="mt-4 text-xs text-slate-500 dark:text-zinc-400 flex items-center gap-1">
                    <span>Active range:</span>
                    <span class="font-bold text-slate-700 dark:text-zinc-300">
                        {{ formatDate(filters.start_date) }} - {{ formatDate(filters.end_date) }}
                    </span>
                </div>
            </div>

            <!-- Total Revenue widget -->
            <div class="relative overflow-hidden rounded-2xl border border-slate-200/80 bg-white p-6 shadow-sm dark:border-zinc-800 dark:bg-zinc-900 transition-all hover:shadow-md">
                <div class="flex items-center justify-between">
                    <div class="space-y-2">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Total Revenue</span>
                        <div class="text-3xl font-black text-emerald-600 dark:text-emerald-500">{{ formatPrice(totalRevenue) }}</div>
                    </div>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600 dark:bg-emerald-950/40 dark:text-emerald-400">
                        <TrendingUp class="h-6 w-6" />
                    </div>
                </div>
                <div class="mt-4 text-xs text-slate-500 dark:text-zinc-400 flex items-center gap-1">
                    <span>Active range:</span>
                    <span class="font-bold text-slate-700 dark:text-zinc-300">
                        {{ formatDate(filters.start_date) }} - {{ formatDate(filters.end_date) }}
                    </span>
                </div>
            </div>
        </div>

        <!-- Detailed Audit List -->
        <div class="overflow-hidden rounded-xl border border-slate-200/80 bg-white shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
            <div class="p-4 border-b border-slate-100 dark:border-zinc-800 bg-slate-50/50 dark:bg-zinc-900/50 flex justify-between items-center">
                <h3 class="text-sm font-semibold text-slate-900 dark:text-white">Transaction Logs in Range</h3>
                <span class="text-xs font-medium bg-slate-150 text-slate-600 dark:bg-zinc-800 dark:text-zinc-400 px-2 py-0.5 rounded-full">
                    {{ transactions.length }} items
                </span>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/20 border-b border-slate-100 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:bg-zinc-900/20 dark:border-zinc-800 dark:text-zinc-400">
                            <th class="p-4">Tx Number</th>
                            <th class="p-4">Customer</th>
                            <th class="p-4">Date</th>
                            <th class="p-4 text-right">Total Amount</th>
                            <th class="p-4">Logged By</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-zinc-800 text-sm">
                        <tr v-if="transactions.length === 0">
                            <td colspan="5" class="p-8 text-center text-slate-400 dark:text-zinc-500">
                                No records found for the selected date range.
                            </td>
                        </tr>
                        <tr v-for="tx in transactions" :key="tx.id" class="hover:bg-slate-50/30 dark:hover:bg-zinc-800/30">
                            <td class="p-4 font-semibold text-slate-900 dark:text-white">
                                {{ tx.number }}
                            </td>
                            <td class="p-4 text-slate-700 dark:text-slate-300">
                                {{ tx.customer_name }}
                            </td>
                            <td class="p-4 text-slate-500 dark:text-slate-400">
                                {{ formatDate(tx.trans_date) }}
                            </td>
                            <td class="p-4 text-right font-semibold text-slate-900 dark:text-white">
                                {{ formatPrice(tx.total_amount) }}
                            </td>
                            <td class="p-4 text-slate-500 dark:text-slate-400">
                                {{ tx.user?.name || 'Unknown' }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>
