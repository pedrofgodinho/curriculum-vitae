import { loadAll } from '$lib/content.server.js'
import type { PageServerLoad } from './$types.js'

export const load: PageServerLoad = () => {
	return loadAll()
}
