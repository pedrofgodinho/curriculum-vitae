<script lang="ts">
	import type { EntryData } from '$lib/types.js'
	import Md from './Md.svelte'

	let { data }: { data: EntryData } = $props()
</script>

<div class="space-y-8">
	{#each data as row}
		{#if row.entries}
			<!-- Grouped entry: multiple roles/degrees at one org -->
			<div>
				<div class="flex items-baseline justify-between gap-4 mb-3">
					<span class="font-semibold text-white">{row.org}</span>
					{#if row.location}
						<span class="text-slate-500 text-sm shrink-0">{row.location}</span>
					{/if}
				</div>
				<div class="space-y-4 pl-4 border-l border-slate-800">
					{#each row.entries as entry}
						<div>
							<div class="flex items-baseline justify-between gap-4">
								<span class="text-slate-200 text-sm font-medium">{entry.title}</span>
								{#if entry.date}
									<span class="text-sky-500 text-xs shrink-0">{entry.date}</span>
								{/if}
							</div>
							{#if entry.details?.length}
								<ul class="mt-2 space-y-1.5">
									{#each entry.details as detail}
										<li class="flex items-start gap-2 text-sm text-slate-400">
											<span class="text-slate-700 mt-0.5 shrink-0 text-xs">▸</span>
											<Md text={detail} />
										</li>
									{/each}
								</ul>
							{/if}
						</div>
					{/each}
				</div>
			</div>
		{:else}
			<!-- Single entry -->
			<div>
				<div class="flex items-baseline justify-between gap-4">
					<span class="font-semibold text-white">{row.title ?? row.org}</span>
					{#if row.date}
						<span class="text-sky-500 text-xs shrink-0">{row.date}</span>
					{/if}
				</div>
				{#if row.org && row.title}
					<p class="text-slate-500 text-sm mt-0.5">
						{[row.org, row.location].filter(Boolean).join(' · ')}
					</p>
				{:else if row.location}
					<p class="text-slate-500 text-sm mt-0.5">{row.location}</p>
				{/if}
				{#if row.details?.length}
					<ul class="mt-2 space-y-1.5">
						{#each row.details as detail}
							<li class="flex items-start gap-2 text-sm text-slate-400">
								<span class="text-slate-700 mt-0.5 shrink-0 text-xs">▸</span>
								<Md text={detail} />
							</li>
						{/each}
					</ul>
				{/if}
			</div>
		{/if}
	{/each}
</div>
