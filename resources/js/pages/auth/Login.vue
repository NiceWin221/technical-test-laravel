<script setup lang="ts">
import { Form, Head, Link, usePage } from '@inertiajs/vue3';
import { Mail } from '@lucide/vue';
import { watch } from 'vue';
import Swal from 'sweetalert2';
import InputError from '@/components/InputError.vue';
import PasswordInput from '@/components/PasswordInput.vue';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Spinner } from '@/components/ui/spinner';
import { register } from '@/routes';
import { store } from '@/routes/login';
import { request } from '@/routes/password';

defineOptions({
    layout: {
        title: 'Welcome back',
        description: 'Please enter your details',
    },
});

defineProps<{
    status?: string;
    canResetPassword: boolean;
}>();

const page = usePage();

watch(
    () => page.props.errors,
    (newErrors) => {
        if (newErrors?.message) {
            const isDark = document.documentElement.classList.contains('dark');
            Swal.fire({
                title: 'Access Denied',
                text: newErrors.message,
                icon: 'warning',
                background: isDark ? '#11131E' : '#ffffff',
                color: isDark ? '#f4f4f5' : '#09090b',
                confirmButtonColor: '#0E5FD9',
                confirmButtonText: 'Ok'
            });
        }
    },
    { deep: true }
);
</script>

<template>
    <Head title="Log in" />

    <div class="w-full max-w-[420px] flex flex-col gap-6">
        <!-- Logo & Header -->
        <div class="flex flex-col items-center gap-4 text-center">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-[#0E5FD9] text-white font-bold text-lg select-none shadow-sm">
                M
            </div>
            <div class="space-y-1">
                <h1 class="text-2xl font-bold text-zinc-900 dark:text-white tracking-tight">Welcome back</h1>
                <p class="text-sm text-zinc-500 dark:text-zinc-400">Please enter your details</p>
            </div>
        </div>

        <!-- White Card -->
        <div class="bg-white dark:bg-[#11131E] border border-[#E2E8F0] dark:border-[#1E2235] rounded-xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] p-8 flex flex-col gap-6">

            <div
                v-if="status"
                class="mb-4 text-center text-sm font-medium text-green-600"
            >
                {{ status }}
            </div>

            <!-- Login Form -->
            <Form
                v-bind="store.form()"
                :reset-on-success="['password']"
                v-slot="{ errors, processing }"
                class="flex flex-col gap-5"
            >
                <div class="grid gap-4">
                    <!-- Email Input -->
                    <div class="grid gap-1.5">
                        <Label for="email" class="text-xs font-bold uppercase tracking-wider text-zinc-500 dark:text-zinc-400">EMAIL ADDRESS</Label>
                        <div class="relative flex items-center">
                            <span class="absolute left-3 flex items-center pointer-events-none text-muted-foreground">
                                <Mail class="size-4" />
                            </span>
                            <Input
                                id="email"
                                type="email"
                                name="email"
                                required
                                autofocus
                                :tabindex="1"
                                autocomplete="email"
                                placeholder="name@company.com"
                                class="pl-10 w-full"
                            />
                        </div>
                        <InputError :message="errors.email" />
                    </div>

                    <!-- Password Input -->
                    <div class="grid gap-1.5">
                        <div class="flex items-center justify-between">
                            <Label for="password" class="text-xs font-bold uppercase tracking-wider text-zinc-500 dark:text-zinc-400">PASSWORD</Label>

                        </div>
                        <PasswordInput
                            id="password"
                            name="password"
                            required
                            :tabindex="2"
                            autocomplete="current-password"
                            placeholder="••••••••"
                        />
                        <InputError :message="errors.password" />
                    </div>

                    <!-- Login Button -->
                    <Button
                        type="submit"
                        class="mt-3 w-full bg-[#0E5FD9] hover:bg-[#0C4FBA] text-white flex items-center justify-center gap-2"
                        :tabindex="4"
                        :disabled="processing"
                        data-test="login-button"
                    >
                        <Spinner v-if="processing" />
                        Login &rarr;
                    </Button>
                </div>
            </Form>
        </div>

        <!-- Footer Area (Outside the Card) -->
        <div class="flex flex-col items-center gap-6 mt-2">
            <div class="text-center text-sm text-zinc-600 dark:text-zinc-400">
                Don't have an account?
                <TextLink :href="register()" class="text-[#0E5FD9] hover:underline font-medium" :tabindex="5">Register</TextLink>
            </div>
            <div class="text-center text-xs text-zinc-400 dark:text-zinc-600 select-none">
                &copy; 2026 Precision Admin. All rights reserved.
            </div>
        </div>
    </div>
</template>
