<script setup lang="ts">
import { Head, usePage, router, useForm } from '@inertiajs/vue3';
import { computed, ref, watch } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { FileText, Plus, Pencil, Trash2, Eye, Search, ArrowLeft, ArrowRight, Calendar, User as UserIcon } from '@lucide/vue';
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
                title: 'Transactions',
                href: '/transactions',
            },
        ],
    },
});

interface Product {
    id: number;
    item_code: string;
    item_name: string;
    price: number;
}

interface TransactionItem {
    id?: number;
    product_id: number;
    qty: number;
    price_at_transaction: number;
    product?: Product;
}

interface Transaction {
    id: number;
    customer_name: string;
    number: string;
    trans_date: string;
    total_amount: number;
    user?: {
        name: string;
    };
    items: TransactionItem[];
}

const props = defineProps<{
    transactions: {
        data: Transaction[];
        links: any[];
        total: number;
        current_page: number;
        last_page: number;
        per_page: number;
        from: number;
        to: number;
    };
    products: Product[];
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
        router.get('/transactions', { search: newVal }, {
            preserveState: true,
            preserveScroll: true,
            replace: true
        });
    }, 300);
});

// Modals State
const isAddOpen = ref(false);
const isEditOpen = ref(false);
const isViewOpen = ref(false);
const selectedTransaction = ref<Transaction | null>(null);

// Temporary Item State for Add/Edit
const newItem = ref({
    product_id: '',
    qty: 1,
    price_at_transaction: 0
});

// Form Setups
const addForm = useForm({
    customer_name: '',
    number: '',
    trans_date: new Date().toISOString().split('T')[0],
    items: [] as Array<{ product_id: number; qty: number; price_at_transaction: number }>
});

const editForm = useForm({
    customer_name: '',
    number: '',
    trans_date: '',
    items: [] as Array<{ product_id: number; qty: number; price_at_transaction: number }>
});

// Helpers
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

const getProductName = (productId: number) => {
    const prod = props.products.find(p => p.id === productId);
    return prod ? prod.item_name : 'Unknown Product';
};

const getProductCode = (productId: number) => {
    const prod = props.products.find(p => p.id === productId);
    return prod ? prod.item_code : '-';
};

// Temp Item Logic
const handleProductChange = (mode: 'add' | 'edit') => {
    const pid = mode === 'add' ? parseInt(newItem.value.product_id) : parseInt(newItem.value.product_id);
    if (!isNaN(pid)) {
        const prod = props.products.find(p => p.id === pid);
        if (prod) {
            newItem.value.price_at_transaction = parseFloat(prod.price.toString());
        }
    } else {
        newItem.value.price_at_transaction = 0;
    }
};

const addTempItem = (mode: 'add' | 'edit') => {
    const pid = parseInt(newItem.value.product_id);
    if (isNaN(pid)) {
        toast.error('Please select a product.');
        return;
    }
    if (newItem.value.qty <= 0) {
        toast.error('Quantity must be greater than 0.');
        return;
    }
    if (newItem.value.price_at_transaction < 0) {
        toast.error('Price cannot be negative.');
        return;
    }

    const form = mode === 'add' ? addForm : editForm;

    // Check if product already exists in items, merge if it does
    const existingIndex = form.items.findIndex(item => item.product_id === pid);
    if (existingIndex > -1) {
        form.items[existingIndex].qty += newItem.value.qty;
        // Keep the latest price input
        form.items[existingIndex].price_at_transaction = newItem.value.price_at_transaction;
        toast.success('Product merged into existing item.');
    } else {
        form.items.push({
            product_id: pid,
            qty: newItem.value.qty,
            price_at_transaction: newItem.value.price_at_transaction
        });
        toast.success('Item added to list.');
    }

    // Reset new item input
    newItem.value = {
        product_id: '',
        qty: 1,
        price_at_transaction: 0
    };
};

const removeTempItem = (mode: 'add' | 'edit', index: number) => {
    const form = mode === 'add' ? addForm : editForm;
    form.items.splice(index, 1);
    toast.success('Item removed from list.');
};

// Total Calculations
const calculateFormTotal = (items: Array<{ qty: number; price_at_transaction: number }>) => {
    return items.reduce((acc, item) => acc + (item.qty * item.price_at_transaction), 0);
};

// Modal Open Triggers
const openAddModal = () => {
    addForm.reset();
    addForm.trans_date = new Date().toISOString().split('T')[0];
    addForm.items = [];
    addForm.clearErrors();
    newItem.value = { product_id: '', qty: 1, price_at_transaction: 0 };
    isAddOpen.value = true;
};

const openEditModal = (tx: Transaction) => {
    editForm.customer_name = tx.customer_name;
    editForm.number = tx.number;
    editForm.trans_date = tx.trans_date ? tx.trans_date.split('T')[0] : '';
    editForm.items = tx.items.map(item => ({
        product_id: item.product_id,
        qty: item.qty,
        price_at_transaction: parseFloat(item.price_at_transaction.toString())
    }));
    editForm.clearErrors();
    newItem.value = { product_id: '', qty: 1, price_at_transaction: 0 };
    selectedTransaction.value = tx;
    isEditOpen.value = true;
};

const openViewModal = (tx: Transaction) => {
    selectedTransaction.value = tx;
    isViewOpen.value = true;
};

// Form Submissions
const submitAdd = () => {
    if (addForm.items.length === 0) {
        toast.error('You must add at least one item.');
        return;
    }
    addForm.post('/transactions', {
        onSuccess: () => {
            isAddOpen.value = false;
            toast.success('Transaction created successfully!');
        }
    });
};

const submitEdit = () => {
    if (!selectedTransaction.value) return;
    if (editForm.items.length === 0) {
        toast.error('You must add at least one item.');
        return;
    }
    editForm.put(`/transactions/${selectedTransaction.value.id}`, {
        onSuccess: () => {
            isEditOpen.value = false;
            toast.success('Transaction updated successfully!');
        }
    });
};

const handleDelete = (tx: Transaction) => {
    const isDark = document.documentElement.classList.contains('dark');
    Swal.fire({
        title: 'Are you sure?',
        text: `You are about to delete transaction ${tx.number}. This action cannot be undone.`,
        icon: 'warning',
        background: isDark ? '#18181b' : '#ffffff',
        color: isDark ? '#f4f4f5' : '#09090b',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Yes, delete it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(`/transactions/${tx.id}`, {
                onSuccess: () => {
                    toast.success('Transaction deleted successfully.');
                }
            });
        }
    });
};
</script>

<template>
    <Head title="Transactions" />

    <div class="flex flex-1 flex-col gap-6 p-6 bg-slate-50/50 dark:bg-zinc-950/20 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
            <div>
                <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-100">
                    Transactions
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400">
                    Manage sales transactions, invoice dates, and customer details.
                </p>
            </div>
            <div>
                <Button @click="openAddModal" class="inline-flex items-center gap-1.5 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg shadow-sm cursor-pointer">
                    <Plus class="h-4 w-4" />
                    New Transaction
                </Button>
            </div>
        </div>

        <!-- Filter & Search Bar -->
        <div class="flex items-center gap-2 max-w-md w-full bg-white dark:bg-zinc-900 border border-slate-200/80 dark:border-zinc-800 rounded-lg px-3 py-1.5 shadow-xs">
            <Search class="h-4 w-4 text-slate-400 dark:text-zinc-500" />
            <input
                v-model="searchQuery"
                type="text"
                placeholder="Search by customer or document number..."
                class="w-full text-sm bg-transparent border-0 outline-hidden focus:ring-0 text-slate-900 dark:text-white placeholder-slate-400"
            />
        </div>

        <!-- Table Card -->
        <div class="overflow-hidden rounded-xl border border-slate-200/80 bg-white shadow-sm dark:border-zinc-800 dark:bg-zinc-900">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/70 border-b border-slate-100 text-xs font-semibold uppercase tracking-wider text-slate-500 dark:bg-zinc-900/50 dark:border-zinc-800 dark:text-zinc-400">
                            <th class="p-4">Tx Number</th>
                            <th class="p-4">Customer Name</th>
                            <th class="p-4">Tx Date</th>
                            <th class="p-4 text-right">Total Amount</th>
                            <th class="p-4">Created By</th>
                            <th class="p-4 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-zinc-800 text-sm">
                        <tr v-if="transactions.data.length === 0">
                            <td colspan="6" class="p-8 text-center text-slate-400 dark:text-zinc-500">
                                <FileText class="h-10 w-10 mx-auto text-slate-300 dark:text-zinc-700 mb-2" />
                                No transactions found.
                            </td>
                        </tr>
                        <tr v-for="tx in transactions.data" :key="tx.id" class="hover:bg-slate-50/30 dark:hover:bg-zinc-800/30">
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
                            <td class="p-4 flex items-center justify-center gap-2">
                                <button
                                    @click="openViewModal(tx)"
                                    class="p-1 border border-slate-200 dark:border-zinc-800 rounded hover:bg-slate-100 dark:hover:bg-zinc-800 text-slate-600 dark:text-zinc-400 cursor-pointer"
                                    title="View Details"
                                >
                                    <Eye class="h-4 w-4" />
                                </button>
                                <button
                                    @click="openEditModal(tx)"
                                    class="p-1 border border-slate-200 dark:border-zinc-800 rounded hover:bg-slate-100 dark:hover:bg-zinc-800 text-blue-600 dark:text-blue-400 cursor-pointer"
                                    title="Edit Transaction"
                                >
                                    <Pencil class="h-4 w-4" />
                                </button>
                                <!-- <button
                                    @click="handleDelete(tx)"
                                    class="p-1 border border-slate-200 dark:border-zinc-800 rounded hover:bg-slate-100 dark:hover:bg-zinc-800 text-red-600 dark:text-red-400 cursor-pointer"
                                    title="Delete Transaction"
                                >
                                    <Trash2 class="h-4 w-4" />
                                </button> -->
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Table Pagination Footer -->
            <div v-if="transactions.last_page > 1" class="flex items-center justify-between border-t border-slate-100 bg-slate-50/50 px-4 py-3 dark:border-zinc-800 dark:bg-zinc-900/50">
                <div class="text-xs text-slate-500 dark:text-zinc-400">
                    Showing <span class="font-semibold text-slate-950 dark:text-white">{{ transactions.from }}</span> to <span class="font-semibold text-slate-950 dark:text-white">{{ transactions.to }}</span> of <span class="font-semibold text-slate-950 dark:text-white">{{ transactions.total }}</span> transactions
                </div>
                <div class="flex gap-2">
                    <button
                        :disabled="transactions.current_page === 1"
                        @click="router.get(transactions.links[0].url)"
                        class="p-1.5 border border-slate-200 dark:border-zinc-800 rounded-lg text-slate-600 dark:text-zinc-400 disabled:opacity-50 cursor-pointer"
                    >
                        <ArrowLeft class="h-4 w-4" />
                    </button>
                    <button
                        :disabled="transactions.current_page === transactions.last_page"
                        @click="router.get(transactions.links[transactions.links.length - 1].url)"
                        class="p-1.5 border border-slate-200 dark:border-zinc-800 rounded-lg text-slate-600 dark:text-zinc-400 disabled:opacity-50 cursor-pointer"
                    >
                        <ArrowRight class="h-4 w-4" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Add Transaction Modal -->
        <Dialog :open="isAddOpen" @update:open="isAddOpen = $event">
            <DialogContent class="!max-w-2xl w-[95%] sm:w-full">
                <DialogHeader>
                    <DialogTitle>Create New Transaction</DialogTitle>
                    <DialogDescription>Record a new transaction with multiple line items.</DialogDescription>
                </DialogHeader>
                <form @submit.prevent="submitAdd" class="space-y-6">
                    <!-- Transaction Header Details -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="grid gap-1.5">
                            <Label for="add_customer_name">Customer Name</Label>
                            <Input id="add_customer_name" v-model="addForm.customer_name" placeholder="John Doe" required />
                            <InputError :message="addForm.errors.customer_name" />
                        </div>
                        <div class="grid gap-1.5">
                            <Label for="add_number">Document Number</Label>
                            <Input id="add_number" v-model="addForm.number" placeholder="TX-2026-0001" required />
                            <InputError :message="addForm.errors.number" />
                        </div>
                        <div class="grid gap-1.5">
                            <Label for="add_trans_date">Transaction Date</Label>
                            <Input id="add_trans_date" type="date" v-model="addForm.trans_date" required />
                            <InputError :message="addForm.errors.trans_date" />
                        </div>
                    </div>

                    <div class="border-t border-slate-200 dark:border-zinc-800 pt-4">
                        <h3 class="text-sm font-semibold text-slate-900 dark:text-slate-100 mb-3">Line Items</h3>
                        
                        <!-- Add Item Row Form -->
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-3 bg-slate-50 dark:bg-zinc-900/50 p-3 rounded-lg border border-slate-200/50 dark:border-zinc-800 mb-4">
                            <div class="grid gap-1">
                                <Label class="text-xs">Product</Label>
                                <select 
                                    v-model="newItem.product_id" 
                                    @change="handleProductChange('add')"
                                    class="flex h-9 w-full rounded-md border border-slate-200 dark:border-zinc-800 bg-white dark:bg-zinc-950/30 px-3 py-1 text-sm shadow-xs transition-colors focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-slate-950 dark:focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50 text-slate-950 dark:text-slate-50"
                                >
                                    <option value="">Select Product</option>
                                    <option v-for="p in products" :key="p.id" :value="p.id">{{ p.item_name }} ({{ formatPrice(p.price) }})</option>
                                </select>
                            </div>
                            <div class="grid gap-1">
                                <Label class="text-xs">Quantity</Label>
                                <Input type="number" min="1" v-model.number="newItem.qty" class="h-9 bg-white dark:bg-zinc-950/30" />
                            </div>
                            <div class="grid gap-1">
                                <Label class="text-xs">Price (IDR)</Label>
                                <Input type="number" min="0" v-model.number="newItem.price_at_transaction" class="h-9 bg-white dark:bg-zinc-950/30" />
                            </div>
                            <div class="flex items-end">
                                <Button type="button" @click="addTempItem('add')" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold h-9 cursor-pointer">
                                    Add Line
                                </Button>
                            </div>
                        </div>

                        <!-- Items Preview List -->
                        <div class="border border-slate-200 dark:border-zinc-800 rounded-lg overflow-hidden max-h-[180px] overflow-y-auto">
                            <table class="w-full text-xs text-left border-collapse">
                                <thead class="bg-slate-50 dark:bg-zinc-900 sticky top-0 border-b border-slate-200 dark:border-zinc-800">
                                    <tr class="text-slate-500 font-semibold uppercase">
                                        <th class="p-2.5">Product</th>
                                        <th class="p-2.5 text-right">Qty</th>
                                        <th class="p-2.5 text-right">Price</th>
                                        <th class="p-2.5 text-right">Total</th>
                                        <th class="p-2.5 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 dark:divide-zinc-800">
                                    <tr v-if="addForm.items.length === 0">
                                        <td colspan="5" class="p-4 text-center text-slate-400">No items added to this transaction.</td>
                                    </tr>
                                    <tr v-for="(item, index) in addForm.items" :key="index" class="hover:bg-slate-50/50 dark:hover:bg-zinc-800/20">
                                        <td class="p-2.5 font-medium text-slate-900 dark:text-slate-100">
                                            <span class="block font-semibold">{{ getProductName(item.product_id) }}</span>
                                            <span class="text-[10px] text-slate-400 font-mono">{{ getProductCode(item.product_id) }}</span>
                                        </td>
                                        <td class="p-2.5 text-right text-slate-700 dark:text-slate-300">{{ item.qty }}</td>
                                        <td class="p-2.5 text-right text-slate-700 dark:text-slate-300">{{ formatPrice(item.price_at_transaction) }}</td>
                                        <td class="p-2.5 text-right font-bold text-slate-900 dark:text-white">{{ formatPrice(item.qty * item.price_at_transaction) }}</td>
                                        <td class="p-2.5 text-center">
                                            <button type="button" @click="removeTempItem('add', index)" class="text-red-500 hover:text-red-700 cursor-pointer">
                                                <Trash2 class="h-4 w-4 mx-auto" />
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Grand Total Display -->
                        <div class="mt-3 flex justify-between items-center bg-slate-100/50 dark:bg-zinc-800/50 p-3 rounded-lg border border-slate-200 dark:border-zinc-800">
                            <span class="text-sm font-semibold text-slate-700 dark:text-zinc-300">Transaction Grand Total</span>
                            <span class="text-lg font-black text-slate-900 dark:text-white">{{ formatPrice(calculateFormTotal(addForm.items)) }}</span>
                        </div>
                    </div>

                    <DialogFooter class="gap-2 sm:justify-end">
                        <DialogClose as-child>
                            <Button type="button" variant="secondary" class="cursor-pointer">Cancel</Button>
                        </DialogClose>
                        <Button type="submit" :disabled="addForm.processing" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold cursor-pointer">
                            Save Transaction
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>

        <!-- Edit Transaction Modal -->
        <Dialog :open="isEditOpen" @update:open="isEditOpen = $event">
            <DialogContent class="!max-w-2xl w-[95%] sm:w-full">
                <DialogHeader>
                    <DialogTitle>Edit Transaction</DialogTitle>
                    <DialogDescription>Modify header and line items of transaction {{ selectedTransaction?.number }}.</DialogDescription>
                </DialogHeader>
                <form @submit.prevent="submitEdit" class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="grid gap-1.5">
                            <Label for="edit_customer_name">Customer Name</Label>
                            <Input id="edit_customer_name" v-model="editForm.customer_name" required />
                            <InputError :message="editForm.errors.customer_name" />
                        </div>
                        <div class="grid gap-1.5">
                            <Label for="edit_number">Document Number</Label>
                            <Input id="edit_number" v-model="editForm.number" required />
                            <InputError :message="editForm.errors.number" />
                        </div>
                        <div class="grid gap-1.5">
                            <Label for="edit_trans_date">Transaction Date</Label>
                            <Input id="edit_trans_date" type="date" v-model="editForm.trans_date" required />
                            <InputError :message="editForm.errors.trans_date" />
                        </div>
                    </div>

                    <div class="border-t border-slate-200 dark:border-zinc-800 pt-4">
                        <h3 class="text-sm font-semibold text-slate-900 dark:text-slate-100 mb-3">Line Items</h3>
                        
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-3 bg-slate-50 dark:bg-zinc-900/50 p-3 rounded-lg border border-slate-200/50 dark:border-zinc-800 mb-4">
                            <div class="grid gap-1">
                                <Label class="text-xs">Product</Label>
                                <select 
                                    v-model="newItem.product_id" 
                                    @change="handleProductChange('edit')"
                                    class="flex h-9 w-full rounded-md border border-slate-200 dark:border-zinc-800 bg-white dark:bg-zinc-950/30 px-3 py-1 text-sm shadow-xs transition-colors focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-slate-950 dark:focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50 text-slate-950 dark:text-slate-50"
                                >
                                    <option value="">Select Product</option>
                                    <option v-for="p in products" :key="p.id" :value="p.id">{{ p.item_name }} ({{ formatPrice(p.price) }})</option>
                                </select>
                            </div>
                            <div class="grid gap-1">
                                <Label class="text-xs">Quantity</Label>
                                <Input type="number" min="1" v-model.number="newItem.qty" class="h-9 bg-white dark:bg-zinc-950/30" />
                            </div>
                            <div class="grid gap-1">
                                <Label class="text-xs">Price (IDR)</Label>
                                <Input type="number" min="0" v-model.number="newItem.price_at_transaction" class="h-9 bg-white dark:bg-zinc-950/30" />
                            </div>
                            <div class="flex items-end">
                                <Button type="button" @click="addTempItem('edit')" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold h-9 cursor-pointer">
                                    Add Line
                                </Button>
                            </div>
                        </div>

                        <div class="border border-slate-200 dark:border-zinc-800 rounded-lg overflow-hidden max-h-[180px] overflow-y-auto">
                            <table class="w-full text-xs text-left border-collapse">
                                <thead class="bg-slate-50 dark:bg-zinc-900 sticky top-0 border-b border-slate-200 dark:border-zinc-800">
                                    <tr class="text-slate-500 font-semibold uppercase">
                                        <th class="p-2.5">Product</th>
                                        <th class="p-2.5 text-right">Qty</th>
                                        <th class="p-2.5 text-right">Price</th>
                                        <th class="p-2.5 text-right">Total</th>
                                        <th class="p-2.5 text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 dark:divide-zinc-800">
                                    <tr v-if="editForm.items.length === 0">
                                        <td colspan="5" class="p-4 text-center text-slate-400">No items added to this transaction.</td>
                                    </tr>
                                    <tr v-for="(item, index) in editForm.items" :key="index" class="hover:bg-slate-50/50 dark:hover:bg-zinc-800/20">
                                        <td class="p-2.5 font-medium text-slate-900 dark:text-slate-100">
                                            <span class="block font-semibold">{{ getProductName(item.product_id) }}</span>
                                            <span class="text-[10px] text-slate-400 font-mono">{{ getProductCode(item.product_id) }}</span>
                                        </td>
                                        <td class="p-2.5 text-right text-slate-700 dark:text-slate-300">{{ item.qty }}</td>
                                        <td class="p-2.5 text-right text-slate-700 dark:text-slate-300">{{ formatPrice(item.price_at_transaction) }}</td>
                                        <td class="p-2.5 text-right font-bold text-slate-900 dark:text-white">{{ formatPrice(item.qty * item.price_at_transaction) }}</td>
                                        <td class="p-2.5 text-center">
                                            <button type="button" @click="removeTempItem('edit', index)" class="text-red-500 hover:text-red-700 cursor-pointer">
                                                <Trash2 class="h-4 w-4 mx-auto" />
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-3 flex justify-between items-center bg-slate-100/50 dark:bg-zinc-800/50 p-3 rounded-lg border border-slate-200 dark:border-zinc-800">
                            <span class="text-sm font-semibold text-slate-700 dark:text-zinc-300">Transaction Grand Total</span>
                            <span class="text-lg font-black text-slate-900 dark:text-white">{{ formatPrice(calculateFormTotal(editForm.items)) }}</span>
                        </div>
                    </div>

                    <DialogFooter class="gap-2 sm:justify-end">
                        <DialogClose as-child>
                            <Button type="button" variant="secondary" class="cursor-pointer">Cancel</Button>
                        </DialogClose>
                        <Button type="submit" :disabled="editForm.processing" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold cursor-pointer">
                            Update Transaction
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>

        <!-- View Transaction Details Modal -->
        <Dialog :open="isViewOpen" @update:open="isViewOpen = $event">
            <DialogContent class="!max-w-2xl w-[95%] sm:w-full">
                <DialogHeader>
                    <DialogTitle class="flex items-center gap-2">
                        <FileText class="h-5 w-5 text-blue-600" />
                        Transaction Details
                    </DialogTitle>
                    <DialogDescription>Read-only detail log for transaction {{ selectedTransaction?.number }}.</DialogDescription>
                </DialogHeader>

                <div v-if="selectedTransaction" class="space-y-6">
                    <!-- Invoice Summary Metadata -->
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 bg-slate-50 dark:bg-zinc-900/50 p-4 rounded-xl border border-slate-200/50 dark:border-zinc-800 text-sm">
                        <div class="grid gap-0.5">
                            <span class="text-xs text-slate-400 dark:text-zinc-500 uppercase font-semibold">Tx Number</span>
                            <span class="font-bold text-slate-900 dark:text-white">{{ selectedTransaction.number }}</span>
                        </div>
                        <div class="grid gap-0.5">
                            <span class="text-xs text-slate-400 dark:text-zinc-500 uppercase font-semibold">Customer</span>
                            <span class="font-semibold text-slate-900 dark:text-white">{{ selectedTransaction.customer_name }}</span>
                        </div>
                        <div class="grid gap-0.5">
                            <span class="text-xs text-slate-400 dark:text-zinc-500 uppercase font-semibold">Date</span>
                            <span class="text-slate-700 dark:text-slate-300 font-medium">{{ formatDate(selectedTransaction.trans_date) }}</span>
                        </div>
                        <div class="grid gap-0.5">
                            <span class="text-xs text-slate-400 dark:text-zinc-500 uppercase font-semibold">Logged By</span>
                            <span class="text-slate-700 dark:text-slate-300 font-medium">{{ selectedTransaction.user?.name || 'Unknown' }}</span>
                        </div>
                    </div>

                    <!-- Items List -->
                    <div class="space-y-3">
                        <h3 class="text-sm font-semibold text-slate-900 dark:text-slate-100">Purchased Items</h3>
                        <div class="border border-slate-200 dark:border-zinc-800 rounded-lg overflow-hidden max-h-[220px] overflow-y-auto">
                            <table class="w-full text-xs text-left border-collapse">
                                <thead class="bg-slate-100 dark:bg-zinc-800 sticky top-0 border-b border-slate-200 dark:border-zinc-800 text-slate-500 uppercase font-semibold">
                                    <tr>
                                        <th class="p-3">Product Name</th>
                                        <th class="p-3 text-right">Qty</th>
                                        <th class="p-3 text-right">Unit Price</th>
                                        <th class="p-3 text-right">Total Price</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 dark:divide-zinc-800">
                                    <tr v-for="(item, index) in selectedTransaction.items" :key="item.id || index" class="hover:bg-slate-50/50 dark:hover:bg-zinc-800/10">
                                        <td class="p-3 font-semibold text-slate-900 dark:text-slate-100">
                                            <span class="block">{{ item.product ? item.product.item_name : getProductName(item.product_id) }}</span>
                                            <span class="text-[10px] text-slate-400 font-mono">{{ item.product ? item.product.item_code : getProductCode(item.product_id) }}</span>
                                        </td>
                                        <td class="p-3 text-right text-slate-700 dark:text-slate-300">{{ item.qty }}</td>
                                        <td class="p-3 text-right text-slate-700 dark:text-slate-300">{{ formatPrice(item.price_at_transaction) }}</td>
                                        <td class="p-3 text-right font-bold text-slate-900 dark:text-white">{{ formatPrice(item.qty * item.price_at_transaction) }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Grand Total Display -->
                    <div class="flex justify-between items-center bg-blue-50/50 dark:bg-blue-950/20 p-4 rounded-xl border border-blue-100 dark:border-blue-950">
                        <span class="text-sm font-bold text-slate-700 dark:text-blue-400">Total Invoice Amount</span>
                        <span class="text-xl font-black text-blue-600 dark:text-blue-400">{{ formatPrice(selectedTransaction.total_amount) }}</span>
                    </div>
                </div>

                <DialogFooter class="sm:justify-end">
                    <DialogClose as-child>
                        <Button type="button" variant="secondary" class="cursor-pointer">Close</Button>
                    </DialogClose>
                </DialogFooter>
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
