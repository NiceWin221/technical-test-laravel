<script setup lang="ts">
import { Head, usePage, router } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { dashboard } from '@/routes';
import AppLayout from '@/layouts/AppLayout.vue';
import { User, UserCheck, Shield, Clock, Check, Loader2 } from '@lucide/vue';
import { toast } from 'vue-sonner';

// Define layout option so breadcrumbs show correctly in the sidebar header
defineOptions({
    layout: {
        breadcrumbs: [
            {
                title: 'Users',
                href: '/users',
            },
        ],
    },
});

const props = defineProps<{
    activeUsers: any[];
    pendingUsers: any[];
}>();

const page = usePage();
const currentUser = computed(() => page.props.auth.user);
const activeTab = ref<'users' | 'requests'>('users');
const acceptingUserId = ref<number | null>(null);

const handleAccept = (userId: number) => {
    acceptingUserId.value = userId;
    router.patch(`/users/${userId}/accept`, {}, {
        onSuccess: () => {
            toast.success('User accepted successfully!');
            acceptingUserId.value = null;
        },
        onError: () => {
            toast.error('Failed to accept user.');
            acceptingUserId.value = null;
        }
    });
};
</script>

<template>
    <Head title="Users" />

    <div class="flex flex-1 flex-col gap-6 p-6 bg-slate-50/50 dark:bg-zinc-950/20 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col gap-1 md:flex-row md:items-center md:justify-between">
            <div>
                <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                    Users
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400">
                    Manage your organization's user accounts and pending registrations.
                </p>
            </div>
        </div>

        <!-- Tab Navigation -->
        <div class="flex border-b border-slate-200 dark:border-zinc-800">
            <button
                @click="activeTab = 'users'"
                :class="[
                    'px-4 py-2 text-sm font-semibold border-b-2 transition-colors duration-200',
                    activeTab === 'users'
                        ? 'border-blue-600 text-blue-600 dark:border-blue-500 dark:text-blue-400'
                        : 'border-transparent text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-300'
                ]"
            >
                Users ({{ activeUsers.length }})
            </button>
            <button
                v-if="currentUser?.role === 'owner'"
                @click="activeTab = 'requests'"
                :class="[
                    'px-4 py-2 text-sm font-semibold border-b-2 transition-colors duration-200',
                    activeTab === 'requests'
                        ? 'border-blue-600 text-blue-600 dark:border-blue-500 dark:text-blue-400'
                        : 'border-transparent text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-300'
                ]"
            >
                User Requests ({{ pendingUsers.length }})
            </button>
        </div>

        <!-- Tab Contents -->
        <div class="overflow-hidden rounded-xl border border-slate-200/80 bg-white shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
            <!-- Active Users List -->
            <div v-if="activeTab === 'users'">
                <div v-if="activeUsers.length === 0" class="flex flex-col items-center justify-center p-12 text-center">
                    <User class="h-10 w-10 text-slate-300 dark:text-zinc-700" />
                    <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">No active users found.</p>
                </div>
                <div v-else class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50/70 border-b border-slate-100 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:bg-zinc-900/50 dark:border-zinc-800 dark:text-zinc-400">
                                <th class="p-4">Name</th>
                                <th class="p-4">Email</th>
                                <th class="p-4">Role</th>
                                <th class="p-4">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-zinc-800 text-sm">
                            <tr v-for="user in activeUsers" :key="user.id" class="hover:bg-slate-50/30 dark:hover:bg-zinc-800/30">
                                <td class="p-4 flex items-center gap-3">
                                    <div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-slate-600 dark:bg-zinc-800 dark:text-zinc-400">
                                        <User class="h-4 w-4" />
                                    </div>
                                    <span class="font-medium text-slate-900 dark:text-white">{{ user.name }}</span>
                                </td>
                                <td class="p-4 text-slate-500 dark:text-slate-400">{{ user.email }}</td>
                                <td class="p-4">
                                    <span :class="[
                                        'inline-flex items-center gap-1 rounded px-2 py-0.5 text-xs font-medium',
                                        user.role === 'owner'
                                            ? 'bg-purple-50 text-purple-700 dark:bg-purple-950/30 dark:text-purple-400'
                                            : 'bg-blue-50 text-blue-700 dark:bg-blue-950/30 dark:text-blue-400'
                                    ]">
                                        <Shield class="h-3 w-3" />
                                        {{ user.role === 'owner' ? 'Owner' : 'Staff' }}
                                    </span>
                                </td>
                                <td class="p-4">
                                    <span class="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-semibold text-emerald-700 dark:bg-emerald-950/30 dark:text-emerald-400">
                                        Active
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- User Requests List -->
            <div v-if="activeTab === 'requests'">
                <div v-if="pendingUsers.length === 0" class="flex flex-col items-center justify-center p-12 text-center">
                    <Clock class="h-10 w-10 text-slate-300 dark:text-zinc-700" />
                    <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">No pending user requests.</p>
                </div>
                <div v-else class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50/70 border-b border-slate-100 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:bg-zinc-900/50 dark:border-zinc-800 dark:text-zinc-400">
                                <th class="p-4">Name</th>
                                <th class="p-4">Email</th>
                                <th class="p-4">Requested Role</th>
                                <th class="p-4">Action</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-zinc-800 text-sm">
                            <tr v-for="user in pendingUsers" :key="user.id" class="hover:bg-slate-50/30 dark:hover:bg-zinc-800/30">
                                <td class="p-4 flex items-center gap-3">
                                    <div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-slate-600 dark:bg-zinc-800 dark:text-zinc-400">
                                        <User class="h-4 w-4" />
                                    </div>
                                    <span class="font-medium text-slate-900 dark:text-white">{{ user.name }}</span>
                                </td>
                                <td class="p-4 text-slate-500 dark:text-slate-400">{{ user.email }}</td>
                                <td class="p-4">
                                    <span class="inline-flex items-center gap-1 rounded px-2 py-0.5 text-xs font-medium bg-amber-50 text-amber-700 dark:bg-amber-950/30 dark:text-amber-400">
                                        <Clock class="h-3 w-3" />
                                        {{ user.role === 'owner' ? 'Owner' : 'Staff' }}
                                    </span>
                                </td>
                                <td class="p-4">
                                    <template v-if="currentUser?.role === 'owner'">
                                        <Button
                                            @click="handleAccept(user.id)"
                                            :disabled="acceptingUserId !== null"
                                            class="inline-flex items-center gap-1.5 bg-blue-600 hover:bg-blue-700 text-white px-3 py-1.5 text-xs font-semibold rounded-lg shadow-sm cursor-pointer disabled:opacity-50"
                                        >
                                            <Loader2 v-if="acceptingUserId === user.id" class="h-3.5 w-3.5 animate-spin" />
                                            <Check v-else class="h-3.5 w-3.5" />
                                            Accept User
                                        </Button>
                                    </template>
                                    <template v-else>
                                        <span class="text-xs text-slate-400 dark:text-zinc-500">Only Owners can approve</span>
                                    </template>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>
