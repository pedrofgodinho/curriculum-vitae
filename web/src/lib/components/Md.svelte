<script lang="ts">
	import { renderMd } from '$lib/markdown.js'

	let { text }: { text: string } = $props()
</script>

<!-- eslint-disable-next-line svelte/no-at-html-tags -->
{@html renderMd(text)}
