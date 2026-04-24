<script lang="ts">
	import type { ListData } from '$lib/types.js'
	import Md from './Md.svelte'

	let { data }: { data: ListData } = $props()
</script>

<ul class="space-y-1.5">
	{#each data as item}
		<li class="flex items-start gap-2.5 text-sm text-slate-300">
			<span class="text-sky-600 mt-0.5 shrink-0 text-xs">▸</span>
			<Md text={item} />
		</li>
	{/each}
</ul>
