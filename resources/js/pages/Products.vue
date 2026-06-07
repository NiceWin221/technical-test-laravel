<script setup lang="ts">
import { Head, usePage, router, useForm } from '@inertiajs/vue3';
import { computed, ref, watch } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Package, Plus, Pencil, Trash2, Search, ArrowLeft, ArrowRight } from '@lucide/vue';
import { toast } from 'vue-sonner';
import Swal from 'sweetalert2';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Button } from '@/components/ui/button';
import InputError from '@/components/InputError.vue';
import {
    Dialog,
    DialogClose,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';

// Define layout option so breadcrumbs show correctly in the sidebar header
defineOptions({
    layout: {
        breadcrumbs: [
            {
                title: 'Products',
                href: '/products',
            },
        ],
    },
});

const props = defineProps<{
    products: {
        data: any[];
        links: any[];
        total: number;
        current_page: number;
        last_page: number;
        per_page: number;
        from: number;
        to: number;
    };
    filters: {
        search: string | null;
    };
}>();

const page = usePage();
const currentUser = computed(() => page.props.auth.user);

// Search Handling
const searchQuery = ref(props.filters.search || '');
let searchTimeout: any = null;

watch(searchQuery, (newVal) => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        router.get('/products', { search: newVal }, {
            preserveState: true,
            preserveScroll: true,
            replace: true
        });
    }, 300);
});

// Modals State
const isAddOpen = ref(false);
const isEditOpen = ref(false);
const editingProduct = ref<any>(null);

// Form Setup
const addForm = useForm({
    item_name: '',
    item_code: '',
    price: '',
});

const editForm = useForm({
    item_name: '',
    item_code: '',
    price: '',
});

const openAddModal = () => {
    addForm.reset();
    addForm.clearErrors();
    isAddOpen.value = true;
};

const openEditModal = (product: any) => {
    editingProduct.value = product;
    editForm.item_name = product.item_name;
    editForm.item_code = product.item_code;
    editForm.price = product.price.toString();
    editForm.clearErrors();
    isEditOpen.value = true;
};

const submitAdd = () => {
    addForm.post('/products', {
        onSuccess: () => {
            isAddOpen.value = false;
            toast.success('Product created successfully!');
        }
    });
};

const submitEdit = () => {
    editForm.put(`/products/${editingProduct.value.id}`, {
        onSuccess: () => {
            isEditOpen.value = false;
            toast.success('Product updated successfully!');
        }
    });
};

const handleDelete = (product: any) => {
    const isDark = document.documentElement.classList.contains('dark');
    Swal.fire({
        title: 'Delete Product?',
        text: `Are you sure you want to delete "${product.item_name}"? This action uses soft delete.`,
        icon: 'warning',
        background: isDark ? '#11131E' : '#ffffff',
        color: isDark ? '#f4f4f5' : '#09090b',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Yes, delete it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(`/products/${product.id}`, {
                onSuccess: () => {
                    toast.success('Product soft-deleted successfully.');
                }
            });
        }
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
</script>

<template>
    <Head title="Products" />

    <div class="flex flex-1 flex-col gap-6 p-6 bg-slate-50/50 dark:bg-zinc-950/20 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col gap-1 md:flex-row md:items-center md:justify-between">
            <div>
                <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                    Products
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400">
                    Manage your organization's product catalog and codes.
                </p>
            </div>
            <div>
                <Button
                    @click="openAddModal"
                    class="bg-blue-600 hover:bg-blue-700 text-white flex items-center gap-1.5 px-4 py-2 text-sm font-semibold rounded-lg shadow-sm cursor-pointer"
                >
                    <Plus class="h-4 w-4" />
                    Add Product
                </Button>
            </div>
        </div>

        <!-- Filters & Search -->
        <div class="flex items-center gap-4 bg-white dark:bg-zinc-900 p-4 rounded-xl border border-slate-200/80 dark:border-zinc-800 shadow-sm">
            <div class="relative flex-1 max-w-sm">
                <span class="absolute left-3 inset-y-0 flex items-center text-slate-400 dark:text-zinc-500">
                    <Search class="h-4 w-4" />
                </span>
                <Input
                    type="text"
                    placeholder="Search by name or code..."
                    v-model="searchQuery"
                    class="pl-10 w-full bg-slate-50 border-slate-200 dark:bg-zinc-950 dark:border-zinc-800"
                />
            </div>
        </div>

        <!-- Data Table Container -->
        <div class="overflow-hidden rounded-xl border border-slate-200/80 bg-white shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
            <div v-if="products.data.length === 0" class="flex flex-col items-center justify-center p-12 text-center">
                <Package class="h-10 w-10 text-slate-300 dark:text-zinc-700" />
                <p class="mt-2 text-sm text-slate-500 dark:text-slate-400">No products found.</p>
            </div>
            <div v-else class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/70 border-b border-slate-100 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:bg-zinc-900/50 dark:border-zinc-800 dark:text-zinc-400">
                            <th class="p-4">SKU / Item Code</th>
                            <th class="p-4">Product Name</th>
                            <th class="p-4">Price</th>
                            <th class="p-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-zinc-800 text-sm">
                        <tr v-for="product in products.data" :key="product.id" class="hover:bg-slate-50/30 dark:hover:bg-zinc-800/30">
                            <td class="p-4 font-mono text-xs font-bold text-slate-900 dark:text-zinc-300">
                                {{ product.item_code }}
                            </td>
                            <td class="p-4">
                                <span class="font-medium text-slate-900 dark:text-white">{{ product.item_name }}</span>
                            </td>
                            <td class="p-4 text-slate-600 dark:text-zinc-300 font-semibold">
                                {{ formatPrice(product.price) }}
                            </td>
                            <td class="p-4 text-right">
                                <div class="inline-flex gap-2">
                                    <button
                                        @click="openEditModal(product)"
                                        class="p-1.5 text-slate-500 hover:text-blue-600 hover:bg-slate-100 dark:text-zinc-400 dark:hover:text-blue-400 dark:hover:bg-zinc-800 rounded-lg transition-colors cursor-pointer"
                                        title="Edit Product"
                                    >
                                        <Pencil class="h-4 w-4" />
                                    </button>
                                    <button
                                        v-if="currentUser?.role === 'owner'"
                                        @click="handleDelete(product)"
                                        class="p-1.5 text-slate-500 hover:text-red-600 hover:bg-slate-100 dark:text-zinc-400 dark:hover:text-red-400 dark:hover:bg-zinc-800 rounded-lg transition-colors cursor-pointer"
                                        title="Delete Product"
                                    >
                                        <Trash2 class="h-4 w-4" />
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Table Pagination Footer -->
            <div v-if="products.last_page > 1" class="flex items-center justify-between border-t border-slate-100 bg-slate-50/50 px-4 py-3 dark:border-zinc-800 dark:bg-zinc-900/50">
                <div class="text-xs text-slate-500 dark:text-zinc-400">
                    Showing <span class="font-semibold text-slate-950 dark:text-white">{{ products.from }}</span> to <span class="font-semibold text-slate-950 dark:text-white">{{ products.to }}</span> of <span class="font-semibold text-slate-950 dark:text-white">{{ products.total }}</span> products
                </div>
                <div class="flex gap-2">
                    <button
                        :disabled="products.current_page === 1"
                        @click="router.get(products.links[0].url)"
                        class="p-1.5 border border-slate-200 dark:border-zinc-800 rounded-lg text-slate-600 dark:text-zinc-400 disabled:opacity-50 cursor-pointer"
                    >
                        <ArrowLeft class="h-4 w-4" />
                    </button>
                    <button
                        :disabled="products.current_page === products.last_page"
                        @click="router.get(products.links[products.links.length - 1].url)"
                        class="p-1.5 border border-slate-200 dark:border-zinc-800 rounded-lg text-slate-600 dark:text-zinc-400 disabled:opacity-50 cursor-pointer"
                    >
                        <ArrowRight class="h-4 w-4" />
                    </button>
                </div>
            </div>
        </div>

        <Dialog :open="isAddOpen" @update:open="isAddOpen = $event">
            <DialogContent class="!max-w-md w-[90%] sm:w-full">
                <DialogHeader>
                    <DialogTitle>Add New Product</DialogTitle>
                    <DialogDescription>Create a new product record in your organization catalog.</DialogDescription>
                </DialogHeader>
                <form @submit.prevent="submitAdd" class="space-y-4">
                    <div class="grid gap-1.5">
                        <Label for="add_item_code">SKU / Item Code</Label>
                        <Input id="add_item_code" v-model="addForm.item_code" placeholder="PROD-001" required />
                        <InputError :message="addForm.errors.item_code" />
                    </div>
                    <div class="grid gap-1.5">
                        <Label for="add_item_name">Product Name</Label>
                        <Input id="add_item_name" v-model="addForm.item_name" placeholder="Premium Coffee Beans" required />
                        <InputError :message="addForm.errors.item_name" />
                    </div>
                    <div class="grid gap-1.5">
                        <Label for="add_price">Price (IDR)</Label>
                        <Input id="add_price" type="number" min="0" v-model="addForm.price" placeholder="45000" required />
                        <InputError :message="addForm.errors.price" />
                    </div>
                    <DialogFooter class="gap-2 sm:justify-end">
                        <DialogClose as-child>
                            <Button type="button" variant="secondary" class="cursor-pointer">Cancel</Button>
                        </DialogClose>
                        <Button type="submit" :disabled="addForm.processing" class="bg-blue-600 hover:bg-blue-700 text-white cursor-pointer">
                            <Spinner v-if="addForm.processing" />
                            Save Product
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>

        <!-- Edit Product Modal -->
        <Dialog :open="isEditOpen" @update:open="isEditOpen = $event">
            <DialogContent class="!max-w-md w-[90%] sm:w-full">
                <DialogHeader>
                    <DialogTitle>Edit Product</DialogTitle>
                    <DialogDescription>Update the product details.</DialogDescription>
                </DialogHeader>
                <form @submit.prevent="submitEdit" class="space-y-4">
                    <div class="grid gap-1.5">
                        <Label for="edit_item_code">SKU / Item Code</Label>
                        <Input id="edit_item_code" v-model="editForm.item_code" required />
                        <InputError :message="editForm.errors.item_code" />
                    </div>
                    <div class="grid gap-1.5">
                        <Label for="edit_item_name">Product Name</Label>
                        <Input id="edit_item_name" v-model="editForm.item_name" required />
                        <InputError :message="editForm.errors.item_name" />
                    </div>
                    <div class="grid gap-1.5">
                        <Label for="edit_price">Price (IDR)</Label>
                        <Input id="edit_price" type="number" min="0" v-model="editForm.price" required />
                        <InputError :message="editForm.errors.price" />
                    </div>
                    <DialogFooter class="gap-2 sm:justify-end">
                        <DialogClose as-child>
                            <Button type="button" variant="secondary" class="cursor-pointer">Cancel</Button>
                        </DialogClose>
                        <Button type="submit" :disabled="editForm.processing" class="bg-blue-600 hover:bg-blue-700 text-white cursor-pointer">
                            <Spinner v-if="editForm.processing" />
                            Update Product
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    </div>
</template>

<style scoped>
/* Chrome, Safari, Edge, Opera */
:deep(input[type="number"]::-webkit-outer-spin-button),
:deep(input[type="number"]::-webkit-inner-spin-button) {
    -webkit-appearance: none;
    appearance: none;
    margin: 0;
}

/* Firefox */
:deep(input[type="number"]) {
    -moz-appearance: textfield;
    appearance: textfield;
}
</style>

