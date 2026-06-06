<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Building, Hash, Calendar, User, Mail, ShieldCheck } from '@lucide/vue';

// Define layout option so breadcrumbs show correctly in the sidebar header
defineOptions({
    layout: {
        breadcrumbs: [
            {
                title: 'Tenant',
                href: '/tenants',
            },
        ],
    },
});

defineProps<{
    tenant: {
        id: number;
        name: string;
        referral_code: string;
        created_at: string;
    };
    owner: {
        id: number;
        name: string;
        email: string;
    } | null;
}>();

const formatDate = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
};
</script>

<template>
    <Head title="Tenant Information" />

    <div class="flex flex-1 flex-col gap-6 p-6 bg-slate-50/50 dark:bg-zinc-950/20 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col gap-1">
            <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                Tenant Info
            </h1>
            <p class="text-sm text-slate-500 dark:text-slate-400">
                Detailed information about your organization's tenant workspace and administrator.
            </p>
        </div>

        <div class="grid gap-6 md:grid-cols-2">
            <!-- Workspace Info Card -->
            <div class="rounded-xl border border-slate-200/80 bg-white p-6 shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
                <div class="flex items-center gap-3 border-b border-slate-100 pb-4 dark:border-zinc-800">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-50 text-blue-600 dark:bg-blue-950/50 dark:text-blue-400">
                        <Building class="h-5 w-5" />
                    </div>
                    <div>
                        <h3 class="font-bold text-slate-900 dark:text-white">Workspace Profile</h3>
                        <p class="text-xs text-slate-500 dark:text-slate-400">Basic settings for this tenant</p>
                    </div>
                </div>

                <div class="mt-6 space-y-4">
                    <div class="flex flex-col gap-1">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Organization Name</span>
                        <div class="flex items-center gap-2 text-slate-800 dark:text-slate-200 font-medium">
                            {{ tenant.name }}
                        </div>
                    </div>

                    <div class="flex flex-col gap-1">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Referral Code</span>
                        <div class="flex items-center gap-2">
                            <span class="bg-blue-50 text-blue-700 dark:bg-blue-950/30 dark:text-blue-400 px-2.5 py-1 rounded-md font-mono font-bold text-sm tracking-wider">
                                {{ tenant.referral_code }}
                            </span>
                        </div>
                    </div>

                    <div class="flex flex-col gap-1">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Registered Date</span>
                        <div class="flex items-center gap-2 text-slate-600 dark:text-zinc-400 text-sm">
                            <Calendar class="h-4 w-4" />
                            {{ formatDate(tenant.created_at) }}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Owner Info Card -->
            <div class="rounded-xl border border-slate-200/80 bg-white p-6 shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
                <div class="flex items-center gap-3 border-b border-slate-100 pb-4 dark:border-zinc-800">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-purple-50 text-purple-600 dark:bg-purple-950/50 dark:text-purple-400">
                        <ShieldCheck class="h-5 w-5" />
                    </div>
                    <div>
                        <h3 class="font-bold text-slate-900 dark:text-white">Workspace Administrator</h3>
                        <p class="text-xs text-slate-500 dark:text-slate-400">Tenant owner information</p>
                    </div>
                </div>

                <div v-if="owner" class="mt-6 space-y-4">
                    <div class="flex flex-col gap-1">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Owner Name</span>
                        <div class="flex items-center gap-2 text-slate-800 dark:text-slate-200 font-medium">
                            <User class="h-4 w-4 text-slate-400" />
                            {{ owner.name }}
                        </div>
                    </div>

                    <div class="flex flex-col gap-1">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Owner Email</span>
                        <div class="flex items-center gap-2 text-slate-800 dark:text-slate-200 font-medium">
                            <Mail class="h-4 w-4 text-slate-400" />
                            {{ owner.email }}
                        </div>
                    </div>

                    <div class="flex flex-col gap-1">
                        <span class="text-xs font-semibold uppercase tracking-wider text-slate-400 dark:text-zinc-500">Authority Level</span>
                        <div>
                            <span class="inline-flex items-center gap-1.5 rounded-full bg-purple-50 px-3 py-0.5 text-xs font-semibold text-purple-700 dark:bg-purple-950/30 dark:text-purple-400">
                                Tenant Owner
                            </span>
                        </div>
                    </div>
                </div>
                <div v-else class="mt-6 flex flex-col items-center justify-center py-12 text-center">
                    <User class="h-10 w-10 text-slate-300 dark:text-zinc-700" />
                    <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">Owner information not available.</p>
                </div>
            </div>
        </div>
    </div>
</template>
