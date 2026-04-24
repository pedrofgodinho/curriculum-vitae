<script lang="ts">
	import Header from '$lib/components/Header.svelte'
	import EntrySection from '$lib/components/EntrySection.svelte'
	import ColumnsSection from '$lib/components/ColumnsSection.svelte'
	import ListSection from '$lib/components/ListSection.svelte'
	import TextSection from '$lib/components/TextSection.svelte'
	import type { PageData } from './$types.js'

	let { data }: { data: PageData } = $props()
</script>

<svelte:head>
	<title>{data.meta.name} — CV</title>
	<meta name="description" content="Curriculum vitae for {data.meta.name}" />
</svelte:head>

<Header meta={data.meta} />

<main class="max-w-4xl mx-auto px-6 py-12 space-y-12">
	{#each data.meta.sections as section}
		{@const sectionData = data.sections[section.module]}
		{#if sectionData}
			<section>
				<h2
					class="flex items-center gap-3 text-xs font-semibold uppercase tracking-widest text-sky-400 mb-5"
				>
					<span aria-hidden="true">◈</span>
					{section.title}
					<span class="flex-1 h-px bg-slate-800" aria-hidden="true"></span>
				</h2>
				{#if sectionData.type === 'entry'}
					<EntrySection data={sectionData.data} />
				{:else if sectionData.type === 'columns'}
					<ColumnsSection data={sectionData.data} />
				{:else if sectionData.type === 'list'}
					<ListSection data={sectionData.data} />
				{:else if sectionData.type === 'text'}
					<TextSection data={sectionData.data} />
				{/if}
			</section>
		{/if}
	{/each}
</main>

<footer class="border-t border-slate-800 mt-4">
	<div class="max-w-4xl mx-auto px-6 py-6 text-center text-slate-600 text-xs">
		{data.meta.name} · Curriculum Vitae
	</div>
</footer>
