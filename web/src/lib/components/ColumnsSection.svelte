<script lang="ts">
	import type { ColumnsData } from '$lib/types.js'
	import Md from './Md.svelte'

	let { data }: { data: ColumnsData } = $props()
</script>

<div class="space-y-2.5">
	{#each data.items as item}
		<div class="grid grid-cols-[minmax(8rem,auto)_1fr] gap-x-6 items-baseline text-sm">
			{#if item.c1}
				<span class="text-sm" class:font-semibold={data.bold === 'c1'} class:text-white={data.bold === 'c1'} class:text-slate-300={data.bold !== 'c1'} class:text-slate-500={data.bold !== 'c1' && !data.bold}>
					<Md text={item.c1} />
				</span>
			{:else}
				<span></span>
			{/if}
			<div class="min-w-0">
				{#if item.c2}
					<span class="text-slate-400" class:font-semibold={data.bold === 'c2'} class:text-white={data.bold === 'c2'}>
						<Md text={item.c2} />
					</span>
				{/if}
				{#if item.c3}
					<span class="text-slate-500 ml-2" class:font-semibold={data.bold === 'c3'} class:text-white={data.bold === 'c3'}>
						<Md text={item.c3} />
					</span>
				{/if}
				{#if item.details}
					<p class="text-slate-500 text-xs mt-0.5"><Md text={item.details} /></p>
				{/if}
			</div>
		</div>
	{/each}
</div>
