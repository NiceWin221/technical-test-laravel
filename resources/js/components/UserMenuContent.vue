<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3';
import { LogOut, Settings } from '@lucide/vue';
import {
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
} from '@/components/ui/dropdown-menu';
import UserInfo from '@/components/UserInfo.vue';
import { logout } from '@/routes';
import { edit } from '@/routes/profile';
import type { User } from '@/types';

import Swal from 'sweetalert2';

type Props = {
    user: User;
};

const handleLogout = (e: MouseEvent) => {
    e.preventDefault();
    const isDark = document.documentElement.classList.contains('dark');
    Swal.fire({
        title: 'Are you sure?',
        text: 'You will be logged out of your session.',
        icon: 'question',
        background: isDark ? '#11131E' : '#ffffff',
        color: isDark ? '#f4f4f5' : '#09090b',
        showCancelButton: true,
        confirmButtonColor: '#0E5FD9',
        cancelButtonColor: '#ef4444',
        confirmButtonText: 'Yes, log out',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(logout().url);
        }
    });
};

defineProps<Props>();
</script>

<template>
    <DropdownMenuLabel class="p-0 font-normal">
        <div class="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
            <UserInfo :user="user" :show-email="true" />
        </div>
    </DropdownMenuLabel>
    <DropdownMenuSeparator />
    <DropdownMenuGroup>
        <DropdownMenuItem :as-child="true">
            <Link class="block w-full cursor-pointer" :href="edit()" prefetch>
                <Settings class="mr-2 h-4 w-4" />
                Settings
            </Link>
        </DropdownMenuItem>
    </DropdownMenuGroup>
    <DropdownMenuSeparator />
    <DropdownMenuItem :as-child="true">
        <button
            class="flex w-full items-center px-2 py-1.5 cursor-pointer text-sm rounded-sm hover:bg-accent hover:text-accent-foreground"
            @click="handleLogout"
            data-test="logout-button"
        >
            <LogOut class="mr-2 h-4 w-4" />
            Log out
        </button>
    </DropdownMenuItem>
</template>
