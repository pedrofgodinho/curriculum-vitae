import { readFileSync } from 'fs'
import { join } from 'path'
import yaml from 'js-yaml'
import type {
	Meta,
	EntryData,
	ColumnsData,
	ColumnsItem,
	ListData,
	TextData,
	SectionEntry
} from './types.js'

const contentDir = join(process.cwd(), '..', 'content')

function load(file: string): unknown {
	return yaml.load(readFileSync(join(contentDir, file), 'utf-8'))
}

function loadMeta(): Meta {
	return load('meta.yaml') as Meta
}

function loadEntry(module: string): EntryData {
	return load(`${module}.yaml`) as EntryData
}

function loadColumns(module: string): ColumnsData {
	const raw = load(`${module}.yaml`)
	if (Array.isArray(raw)) {
		return { items: raw as ColumnsItem[] }
	}
	return raw as ColumnsData
}

function loadList(module: string): ListData {
	return load(`${module}.yaml`) as ListData
}

function loadText(module: string): TextData {
	// Read raw lines — plain YAML scalars fold newlines to spaces,
	// so we bypass the parser to preserve each line as its own paragraph.
	const raw = readFileSync(join(contentDir, `${module}.yaml`), 'utf-8')
	return raw.split('\n').map((s) => s.trim()).filter(Boolean)
}

export function loadAll(): { meta: Meta; sections: Record<string, SectionEntry> } {
	const meta = loadMeta()
	const sections: Record<string, SectionEntry> = {}

	for (const section of meta.sections) {
		switch (section.type) {
			case 'entry':
				sections[section.module] = { type: 'entry', data: loadEntry(section.module) }
				break
			case 'columns':
				sections[section.module] = { type: 'columns', data: loadColumns(section.module) }
				break
			case 'list':
				sections[section.module] = { type: 'list', data: loadList(section.module) }
				break
			case 'text':
				sections[section.module] = { type: 'text', data: loadText(section.module) }
				break
		}
	}

	return { meta, sections }
}
