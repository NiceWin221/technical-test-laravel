<script setup lang="ts">
import { computed } from 'vue';
import { User as UserIcon } from '@lucide/vue';
import type { User } from '@/types';

type Props = {
    user: User;
    showEmail?: boolean;
};

const props = withDefaults(defineProps<Props>(), {
    showEmail: false,
});
</script>

<template>
    <div class="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-slate-100 text-slate-600 dark:bg-zinc-800 dark:text-zinc-400">
        <UserIcon class="h-4 w-4" />
    </div>

    <div class="grid flex-1 text-left text-sm leading-tight ml-2">
        <span class="truncate font-medium">{{ user.name }}</span>
        <span v-if="showEmail" class="truncate text-xs text-muted-foreground leading-none mt-1">{{
            user.email
        }}</span>
    </div>
</template>
