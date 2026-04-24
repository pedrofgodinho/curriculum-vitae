<script lang="ts">
	import type { TextData } from '$lib/types.js'
	import Md from './Md.svelte'

	let { data }: { data: TextData } = $props()
</script>

<div class="space-y-3">
	{#each data as paragraph}
		<p class="text-slate-300 leading-relaxed text-sm"><Md text={paragraph} /></p>
	{/each}
</div>
