<script setup lang="ts">
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { User as UserIcon, Mail, Building, KeyRound, ArrowLeft, ArrowRight, Check } from '@lucide/vue';
import InputError from '@/components/InputError.vue';
import PasswordInput from '@/components/PasswordInput.vue';
import TextLink from '@/components/TextLink.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Spinner } from '@/components/ui/spinner';
import { login } from '@/routes';

defineProps<{
    passwordRules: string;
}>();

defineOptions({
    layout: {
        title: 'Create an account',
        description: 'Enter your details to join the Precision Admin platform.',
    },
});

// Setup Inertia Form with all fields for the wizard
const form = useForm({
    name: '',
    email: '',
    password: '',
    password_confirmation: '',
    registration_type: 'create', // 'create' | 'join'
    company_name: '',
    referral_code: '',
});

// Manage step state
const currentStep = ref<1 | 2>(1);

// Client-side validations for Step 1
const step1Errors = ref({
    name: '',
    email: '',
    password: '',
    password_confirmation: '',
});

const validateStep1 = () => {
    let isValid = true;
    step1Errors.value = { name: '', email: '', password: '', password_confirmation: '' };

    if (!form.name.trim()) {
        step1Errors.value.name = 'Full Name is required.';
        isValid = false;
    }
    if (!form.email.trim()) {
        step1Errors.value.email = 'Email address is required.';
        isValid = false;
    } else if (!/\S+@\S+\.\S+/.test(form.email)) {
        step1Errors.value.email = 'Please enter a valid email address.';
        isValid = false;
    }
    if (!form.password) {
        step1Errors.value.password = 'Password is required.';
        isValid = false;
    } else if (form.password.length < 8) {
        step1Errors.value.password = 'Password must be at least 8 characters.';
        isValid = false;
    }
    if (form.password !== form.password_confirmation) {
        step1Errors.value.password_confirmation = 'Passwords do not match.';
        isValid = false;
    }

    if (isValid) {
        currentStep.value = 2;
    }
};

const submit = () => {
    form.post('/register', {
        onFinish: () => form.reset('password', 'password_confirmation'),
    });
};
</script>

<template>
    <Head title="Register" />

    <div class="w-full max-w-[480px] flex flex-col gap-6">
        <!-- Logo & Header -->
        <div class="flex flex-col items-center gap-4 text-center">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-[#0E5FD9] text-white font-bold text-lg select-none shadow-sm">
                M
            </div>
            <div class="space-y-1">
                <h1 class="text-2xl font-bold text-zinc-900 dark:text-white tracking-tight">Create an account</h1>
                <p class="text-sm text-zinc-500 dark:text-zinc-400">Enter your details to join the Precision Admin platform.</p>
            </div>
        </div>

        <!-- Progress Steps Indicator -->
        <div class="flex items-center justify-center gap-2 px-4 py-2 bg-slate-100/80 dark:bg-zinc-900/50 rounded-lg text-xs font-semibold text-zinc-500 select-none">
            <div :class="['flex items-center gap-1.5', currentStep === 1 ? 'text-[#0E5FD9] dark:text-blue-400' : 'text-emerald-600 dark:text-emerald-400']">
                <span :class="['flex h-5 w-5 items-center justify-center rounded-full text-[10px] font-bold text-white', currentStep === 1 ? 'bg-[#0E5FD9]' : 'bg-emerald-600']">
                    <Check v-if="currentStep > 1" class="h-3 w-3" />
                    <span v-else>1</span>
                </span>
                Account Info
            </div>
            <div class="h-px w-8 bg-zinc-300 dark:bg-zinc-700"></div>
            <div :class="['flex items-center gap-1.5', currentStep === 2 ? 'text-[#0E5FD9] dark:text-blue-400' : 'text-zinc-400']">
                <span :class="['flex h-5 w-5 items-center justify-center rounded-full text-[10px] font-bold text-white', currentStep === 2 ? 'bg-[#0E5FD9]' : 'bg-zinc-300 dark:bg-zinc-700']">
                    2
                </span>
                Workspace Selection
            </div>
        </div>

        <!-- White Card Container -->
        <div class="bg-white dark:bg-[#11131E] border border-[#E2E8F0] dark:border-[#1E2235] rounded-xl shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] p-8 flex flex-col gap-6">
            
            <form @submit.prevent="submit" class="flex flex-col gap-5">
                
                <!-- STEP 1: Account Information -->
                <div v-if="currentStep === 1" class="flex flex-col gap-4">
                    <!-- Full Name -->
                    <div class="grid gap-1.5">
                        <Label for="name" class="text-sm font-semibold text-zinc-700 dark:text-zinc-300">Full Name</Label>
                        <div class="relative flex items-center">
                            <span class="absolute left-3 flex items-center pointer-events-none text-muted-foreground">
                                <UserIcon class="size-4" />
                            </span>
                            <Input
                                id="name"
                                type="text"
                                v-model="form.name"
                                required
                                autofocus
                                placeholder="John Doe"
                                class="pl-10 w-full"
                            />
                        </div>
                        <InputError :message="step1Errors.name || form.errors.name" />
                    </div>

                    <!-- Email Address -->
                    <div class="grid gap-1.5">
                        <Label for="email" class="text-sm font-semibold text-zinc-700 dark:text-zinc-300">Email Address</Label>
                        <div class="relative flex items-center">
                            <span class="absolute left-3 flex items-center pointer-events-none text-muted-foreground">
                                <Mail class="size-4" />
                            </span>
                            <Input
                                id="email"
                                type="email"
                                v-model="form.email"
                                required
                                placeholder="name@company.com"
                                class="pl-10 w-full"
                            />
                        </div>
                        <InputError :message="step1Errors.email || form.errors.email" />
                    </div>

                    <!-- Password -->
                    <div class="grid gap-1.5">
                        <Label for="password" class="text-sm font-semibold text-zinc-700 dark:text-zinc-300">Password</Label>
                        <PasswordInput
                            id="password"
                            v-model="form.password"
                            required
                            placeholder="••••••••"
                            :passwordrules="passwordRules"
                        />
                        <InputError :message="step1Errors.password || form.errors.password" />
                    </div>

                    <!-- Confirm Password -->
                    <div class="grid gap-1.5">
                        <Label for="password_confirmation" class="text-sm font-semibold text-zinc-700 dark:text-zinc-300">Confirm Password</Label>
                        <PasswordInput
                            id="password_confirmation"
                            v-model="form.password_confirmation"
                            required
                            placeholder="••••••••"
                            :passwordrules="passwordRules"
                        />
                        <InputError :message="step1Errors.password_confirmation || form.errors.password_confirmation" />
                    </div>

                    <!-- Next Step Button -->
                    <Button
                        type="button"
                        @click="validateStep1"
                        class="mt-3 w-full bg-[#0E5FD9] hover:bg-[#0C4FBA] text-white flex items-center justify-center gap-2 cursor-pointer"
                    >
                        Continue to Workspace
                        <ArrowRight class="h-4 w-4" />
                    </Button>
                </div>

                <!-- STEP 2: Tenant/Workspace Selection -->
                <div v-else class="flex flex-col gap-5">
                    
                    <!-- Registration Type Selection -->
                    <div class="grid grid-cols-2 gap-3">
                        <button
                            type="button"
                            @click="form.registration_type = 'create'"
                            :class="[
                                'flex flex-col items-center justify-center p-4 rounded-lg border text-center transition-all cursor-pointer',
                                form.registration_type === 'create'
                                    ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-950/20 text-blue-700 dark:text-blue-400 font-bold'
                                    : 'border-slate-200 dark:border-zinc-800 text-slate-600 dark:text-zinc-400'
                            ]"
                        >
                            <Building class="h-5 w-5 mb-2" />
                            <span class="text-xs uppercase tracking-wider font-semibold">New Tenant</span>
                            <span class="text-[10px] opacity-70 mt-1">Create organization</span>
                        </button>
                        <button
                            type="button"
                            @click="form.registration_type = 'join'"
                            :class="[
                                'flex flex-col items-center justify-center p-4 rounded-lg border text-center transition-all cursor-pointer',
                                form.registration_type === 'join'
                                    ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-950/20 text-blue-700 dark:text-blue-400 font-bold'
                                    : 'border-slate-200 dark:border-zinc-800 text-slate-600 dark:text-zinc-400'
                            ]"
                        >
                            <KeyRound class="h-5 w-5 mb-2" />
                            <span class="text-xs uppercase tracking-wider font-semibold">Join Tenant</span>
                            <span class="text-[10px] opacity-70 mt-1">Use referral code</span>
                        </button>
                    </div>

                    <InputError :message="form.errors.registration_type" />

                    <!-- Option 1 Fields: Create Workspace -->
                    <div v-if="form.registration_type === 'create'" class="grid gap-1.5 animate-fadeIn">
                        <Label for="company_name" class="text-sm font-semibold text-zinc-700 dark:text-zinc-300">Company / Tenant Name</Label>
                        <div class="relative flex items-center">
                            <span class="absolute left-3 flex items-center pointer-events-none text-muted-foreground">
                                <Building class="size-4" />
                            </span>
                            <Input
                                id="company_name"
                                type="text"
                                v-model="form.company_name"
                                required
                                placeholder="My Awesome Company"
                                class="pl-10 w-full"
                            />
                        </div>
                        <InputError :message="form.errors.company_name" />
                    </div>

                    <!-- Option 2 Fields: Join Workspace -->
                    <div v-else class="grid gap-1.5 animate-fadeIn">
                        <Label for="referral_code" class="text-sm font-semibold text-zinc-700 dark:text-zinc-300">Referral Code</Label>
                        <div class="relative flex items-center">
                            <span class="absolute left-3 flex items-center pointer-events-none text-muted-foreground">
                                <KeyRound class="size-4" />
                            </span>
                            <Input
                                id="referral_code"
                                type="text"
                                v-model="form.referral_code"
                                required
                                placeholder="ABC123XY"
                                class="pl-10 w-full font-mono uppercase tracking-widest"
                            />
                        </div>
                        <InputError :message="form.errors.referral_code" />
                    </div>

                    <!-- Navigation Action Buttons -->
                    <div class="flex gap-3 mt-3">
                        <Button
                            type="button"
                            variant="outline"
                            @click="currentStep = 1"
                            class="flex-1 flex items-center justify-center gap-2 cursor-pointer border-slate-200 dark:border-zinc-800"
                        >
                            <ArrowLeft class="h-4 w-4" />
                            Back
                        </Button>
                        <Button
                            type="submit"
                            :disabled="form.processing"
                            class="flex-1 bg-[#0E5FD9] hover:bg-[#0C4FBA] text-white flex items-center justify-center gap-2 cursor-pointer"
                        >
                            <Spinner v-if="form.processing" />
                            Register Account
                        </Button>
                    </div>
                </div>

                <!-- Footer inside the Card -->
                <div class="text-center text-sm text-zinc-600 dark:text-zinc-400 mt-2">
                    Already have an account?
                    <TextLink
                        :href="login()"
                        class="text-[#0E5FD9] hover:underline font-medium"
                        >Log in</TextLink
                    >
                </div>
            </form>
        </div>

        <!-- Footer Area (Outside the Card) -->
        <div class="text-center text-[10px] font-bold text-zinc-400 dark:text-zinc-600 tracking-wider uppercase select-none mt-2">
            Precision Admin Enterprise
        </div>
    </div>
</template>

<style scoped>
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(6px); }
    to { opacity: 1; transform: translateY(0); }
}
.animate-fadeIn {
    animation: fadeIn 0.2s ease-out forwards;
}
</style>
