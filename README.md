# CV

A data-driven CV system. All content lives in YAML files under `content/`; a Typst template turns them into a PDF. Changing any YAML file and recompiling is all it takes to update the CV.

## Prerequisites

- [Typst](https://typst.app) — for compiling and previewing locally
- [Docker](https://docker.com) — only needed for the production build

## Quickstart

1. Fill in your details in the files under `content/` (see below).
2. Run the live preview:

```bash
typst watch --root . --font-path pdf/fonts pdf/cv.typ pdf/cv.pdf
```

Open `pdf/cv.pdf` in a viewer that refreshes automatically on file change — SumatraPDF on Windows, Skim on macOS, Evince on Linux all work. Every time you save a YAML file the PDF updates.

To compile once without watching:

```bash
typst compile --root . --font-path pdf/fonts pdf/cv.typ pdf/cv.pdf
```

If you use VS Code, the Tinymist extension picks up the font path automatically from `.vscode/settings.json` and gives you an inline preview.

---

## Content files

Everything you edit lives in `content/`. The section order in the PDF is controlled by `meta.yaml`; the rest are just data.

### `meta.yaml` — header and section order

```yaml
name: "Your Name"
title: "Your Current Title"
affiliation:
  department: "Your Institution"
  institution: "Your Department"
  # address: "Building, Room, City, State"   # uncomment to show address
contact:
  email: "you@example.com"
  # website: "https://yoursite.com"          # uncomment to show website
links:                                       # omit any key to hide that icon
  linkedin: "username"
  github: "username"
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

The `sections` list controls what appears in the PDF and in what order. Comment out or remove any section you don't need.

Each section takes two keys:

- **`title`** — the heading printed in the PDF.
- **`type`** — which renderer to use:
  - `text` — one or more paragraphs of prose. Each string in the array becomes a paragraph.
  - `entry` — full blocks with title, organisation, date, and bullet-point details. Supports grouping multiple roles or degrees under one institution.
  - `columns` — a compact three-column layout: left column, main text, optional right column. Supports an optional `bold` key to control which column is bolded.
  - `list` — a plain bulleted list. Each item in the YAML file becomes one bullet.

---

### `summary.yaml` — prose paragraphs

Each string in the array is rendered as a separate paragraph:

```yaml
- "First paragraph of your summary."
- "Second paragraph with **bold** and _italic_ text."
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

A simple array of items. By default the main text (`c2`) is bolded:

```yaml
- c1: "2024"                       # left column — date, rank, or similar
  c2: "Award or achievement name"  # main text (bolded by default)
  c3: "Issuing body"               # right column — optional
  details: "Extra line of detail"  # optional
```

---

### `skills.yaml`, `languages.yaml` — columns with left-bolding

These use the `bold: c1` option so the category label on the left is bolded instead of the value on the right:

```yaml
bold: c1
items:
  - c1: "Category"     # bolded
    c2: "Value, Value, Value"
```

Example:

```yaml
bold: c1
items:
  - c1: "Programming"
    c2: "Rust, Python, TypeScript, Go"
  - c1: "DevOps"
    c2: "Docker, Ansible, GitHub Actions"
```

---

### `hobbies.yaml` — plain list

A flat array of strings, one per bullet:

```yaml
- "Item one with **bold** text"
- "Item two with a [link](https://example.com)"
- "Plain item"
```

---

## Formatting

`title`, `c2`, `details`, and summary strings support a small subset of Markdown:

| Syntax | Result |
|---|---|
| `**text**` | Bold |
| `_text_` | Italic |
| `[label](url)` | Hyperlink |

For multi-line `details`, use a literal block scalar:

```yaml
details: |
  First line.
  Second line.
```

Special characters like `$`, `#`, `@`, `[`, `]` don't need escaping — they're treated as plain text.

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

## Production build

CI compiles the PDF automatically on every push to `main` and attaches it to a rolling GitHub Release tagged `latest`. You can download the latest PDF from the Releases page without cloning the repo.

To build locally with Docker (same environment as CI):

```bash
mkdir -p dist && docker compose run --rm pdf
```

The output goes to `dist/cv.pdf`.

---

## Project layout

```
content/        YAML data — edit these
pdf/            Typst source
  cv.typ        Entry point
  utils.typ     Shared renderers
  fonts/        Bundled fonts
  assets/       Avatar and logos
.github/
  workflows/    CI pipelines
docker-compose.yml
```
