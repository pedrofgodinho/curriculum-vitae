function escapeHtml(text: string): string {
	return text
		.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/"/g, '&quot;')
}

export function renderMd(text: string): string {
	let result = ''
	let remaining = text

	while (remaining.length > 0) {
		const patterns: Array<{ re: RegExp; render: (m: RegExpExecArray) => string }> = [
			{ re: /\*\*(.+?)\*\*/, render: (m) => `<strong class="text-white font-semibold">${renderMd(m[1])}</strong>` },
			{ re: /_(.+?)_/, render: (m) => `<em>${renderMd(m[1])}</em>` },
			{
				re: /\[([^\]]+)\]\((https?:\/\/[^)]+)\)/,
				render: (m) =>
					`<a href="${escapeHtml(m[2])}" target="_blank" rel="noopener noreferrer" class="text-sky-400 hover:text-sky-300 underline underline-offset-2 transition-colors">${renderMd(m[1])}</a>`
			},
			{ re: /\n/, render: () => '<br>' }
		]

		let earliest: { index: number; end: number; html: string } | null = null

		for (const { re, render } of patterns) {
			const m = re.exec(remaining)
			if (m !== null && (earliest === null || m.index < earliest.index)) {
				earliest = { index: m.index, end: m.index + m[0].length, html: render(m) }
			}
		}

		if (earliest === null) {
			result += escapeHtml(remaining)
			break
		}

		result += escapeHtml(remaining.slice(0, earliest.index))
		result += earliest.html
		remaining = remaining.slice(earliest.end)
	}

	return result
}
