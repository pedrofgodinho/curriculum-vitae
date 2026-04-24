import { execSync } from 'child_process'
import { copyFileSync, existsSync, readFileSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'
import yaml from 'js-yaml'

const webDir = join(dirname(fileURLToPath(import.meta.url)), '..')
const contentDir = join(webDir, '..', 'content')
const staticDir = join(webDir, 'static')

// Copy photo from content/ to static/ if defined in meta.yaml
const meta = yaml.load(readFileSync(join(contentDir, 'meta.yaml'), 'utf-8'))
if (meta.photo?.file) {
	const src = join(contentDir, meta.photo.file)
	const dest = join(staticDir, meta.photo.file)
	if (existsSync(src)) {
		copyFileSync(src, dest)
		console.log(`Copied content/${meta.photo.file} → static/${meta.photo.file}`)
	} else {
		console.warn(`Warning: photo not found at content/${meta.photo.file}`)
	}
}

// Compile PDF — skipped in CI since it's compiled in a dedicated step before npm run build
if (!process.env.CI) {
	execSync('typst compile --root .. --font-path ../pdf/fonts ../pdf/cv.typ static/cv.pdf', {
		stdio: 'inherit',
		cwd: webDir
	})
}
