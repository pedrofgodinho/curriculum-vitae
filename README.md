# CV

A data-driven CV system. All content lives in YAML files under `content/`; a Typst template turns them into a PDF and a SvelteKit site renders the same data as a website. Changing any YAML file and recompiling is all it takes to update both outputs.

## Prerequisites

- [Typst](https://typst.app) — for compiling and previewing the PDF locally
- Node 22+ — for the website

## Quickstart

### PDF

Run the live preview:

```bash
typst watch --root . --font-path pdf/fonts pdf/cv.typ pdf/cv.pdf
```

Open `pdf/cv.pdf` in a viewer that refreshes automatically — SumatraPDF on Windows, Skim on macOS, Evince on Linux. Every time you save a YAML file the PDF updates.

To compile once without watching:

```bash
typst compile --root . --font-path pdf/fonts pdf/cv.typ pdf/cv.pdf
```

If you use VS Code, the Tinymist extension picks up the font path automatically from `.vscode/settings.json`.

### Website

```bash
cd web
npm install
npm run dev        # dev server at http://localhost:5173
npm run build      # production build → web/build/
npm run preview    # preview the production build
```

`npm run build` automatically compiles the PDF first and bundles it into the site as `/cv.pdf`, so the download link on the site always matches the live content.

---

## Content files

Everything you edit lives in `content/`. The section order in both outputs is controlled by `meta.yaml`; the rest are just data.

### `meta.yaml` — header and section order

```yaml
name: "Your Name"
title: "Your Current Title"
affiliation:
  department: "Your Institution"
  institution: "Your Department"
  # address: "Building, Room, City, State"   # uncomment to show address (PDF only)
contact:
  email: "you@example.com"
  website: "https://yoursite.com"            # PDF only — omitted on the website to avoid self-linking
links:                                       # omit any key to hide that icon
  linkedin: "username"
  github: "username"
  repo: "username/repo"                      # website only — adds Source and PDF links to the header
  # scholar: "google_scholar_user_id"
  # orcid: "0000-0000-0000-0000"
  # x: "username"
sections:
  - module: summary
    title: "Summary"
    type: text
  - module: education
    title: "Education"
    type: entry
  - module: research
    title: "Research & Projects"
    type: entry
  - module: experience
    title: "Experience"
    type: entry
  - module: awards
    title: "Awards and Honors"
    type: columns
  - module: skills
    title: "Skills"
    type: columns
  - module: hobbies
    title: "Hobbies and Interests"
    type: list
  - module: languages
    title: "Languages"
    type: columns
```

The `sections` list controls what appears and in what order. Comment out or remove any section you don't need.

Each section takes two keys:

- **`title`** — the heading printed in the output.
- **`type`** — which renderer to use:
  - `text` — one or more paragraphs of prose.
  - `entry` — full blocks with title, organisation, date, and bullet-point details. Supports grouping multiple roles or degrees under one institution.
  - `columns` — a compact three-column layout: left column, main text, optional right column. Supports an optional `bold` key to control which column is bolded.
  - `list` — a plain bulleted list.

---

### `summary.yaml` — prose paragraphs

Each line is rendered as a separate paragraph:

```
First paragraph of your summary.
Second paragraph with **bold** and _italic_ text.
```

---

### `education.yaml`, `research.yaml`, `experience.yaml`

These all share the same structure. Each item is either a single entry or a group of entries under a shared organisation.

**Single entry:**

```yaml
- title: "Job Title or Course Name"
  date: "2022–Present"        # omit for education (put the date in the title instead)
  org: "Company or Institution"
  location: "City, Country"   # omit if not needed
  details:
    - "What you did"
    - "Another point"
```

**Grouped entries** (multiple roles or degrees at the same place):

```yaml
- org: "University Name"
  location: "City, Country"
  entries:
    - title: "M.Sc. in Computer Science, May 2026"
      details:
        - "_Thesis:_ Your thesis title"
        - "_Advisors:_ Prof. A and Prof. B"
    - title: "B.Sc. in Computer Science, May 2022"
```

For education, the date is conventionally written at the end of the title string rather than as a separate field.

---

### `awards.yaml` — compact columns

```yaml
- c1: "2024"                       # left column — date, rank, or similar
  c2: "Award or achievement name"  # main text
  c3: "Issuing body"               # right column — optional
  details: "Extra line of detail"  # optional
```

---

### `skills.yaml`, `languages.yaml` — columns with left-bolding

```yaml
bold: c1
items:
  - c1: "Category"           # bolded
    c2: "Value, Value, Value"
```

---

### `hobbies.yaml` — plain list

```yaml
- "Item one with **bold** text"
- "Item two with a [link](https://example.com)"
- "Plain item"
```

---

## Formatting

`title`, `c2`, `details`, and summary text support a small Markdown subset:

| Syntax | Result |
|---|---|
| `**text**` | Bold |
| `_text_` | Italic |
| `[label](url)` | Hyperlink |

Special characters like `$`, `#`, `@`, `[`, `]` don't need escaping.

---

## Hiding a section

Comment out the module in `meta.yaml`:

```yaml
sections:
  - module: education
    title: "Education"
    type: entry
  # - module: awards
  #   title: "Awards and Honors"
  #   type: columns
```

---

## Deployment

### PDF

CI compiles the PDF automatically on every push to `main` and attaches it to a rolling GitHub Release tagged `latest`.

To build locally:

```bash
typst compile --root . --font-path pdf/fonts pdf/cv.typ dist/cv.pdf
```

### Website

CI builds and deploys the site to GitHub Pages on every push to `main`. The PDF is compiled as part of the build and served at `/cv.pdf`.

To enable GitHub Pages: go to **Settings → Pages → Source** and select **GitHub Actions**.

For a custom domain, add your domain to `web/static/CNAME`:

```
cv.yourdomain.com
```

---

## Project layout

```
content/          YAML data — edit these
pdf/              Typst source
  cv.typ          Entry point
  utils.typ       Shared renderers
  fonts/          Bundled fonts (gitignored)
web/              SvelteKit website
  src/
    lib/          Shared utilities and components
    routes/       Pages
  static/         Static assets (CNAME goes here)
.github/
  workflows/
    release-pdf.yml   Compiles PDF → GitHub Release
    deploy-web.yml    Builds site → GitHub Pages
```
