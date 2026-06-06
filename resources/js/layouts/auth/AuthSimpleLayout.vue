<script setup lang="ts">
// AuthSimpleLayout berfungsi sebagai layout penengah (centered wrapper) dengan background abu-abu muda
</script>

<template>
    <div
        class="flex min-h-svh flex-col items-center justify-center bg-[#F8F9FC] dark:bg-[#0A0B10] p-6 md:p-10"
    >
        <slot />
    </div>
</template>
