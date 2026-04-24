export interface Meta {
	name: string
	photo?: {
		file: string
		web?: boolean
		pdf?: boolean
	}
	title: string
	affiliation?: {
		department?: string
		institution?: string
		address?: string
	}
	contact?: {
		email?: string
		website?: string
	}
	links?: {
		linkedin?: string
		github?: string
		scholar?: string
		orcid?: string
		x?: string
		repo?: string
	}
	sections: Section[]
}

export interface Section {
	module: string
	title: string
	type: 'text' | 'entry' | 'columns' | 'list' | 'publications'
}

export interface EntryItem {
	title: string
	date?: string
	details?: string[]
}

export interface EntryRow {
	org?: string
	location?: string
	date?: string
	entries?: EntryItem[]
	title?: string
	details?: string[]
}

export type EntryData = EntryRow[]

export interface ColumnsItem {
	c1?: string
	c2?: string
	c3?: string
	details?: string
}

export interface ColumnsData {
	bold?: 'c1' | 'c2' | 'c3'
	items: ColumnsItem[]
}

export type ListData = string[]
export type TextData = string[]

export type SectionEntry =
	| { type: 'entry'; data: EntryData }
	| { type: 'columns'; data: ColumnsData }
	| { type: 'list'; data: ListData }
	| { type: 'text'; data: TextData }
