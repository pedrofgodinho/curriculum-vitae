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
  department: "Your Department"
  institution: "Your Institution"
  address: "Building, Room, City, State"   # omit the whole line to hide
contact:
  email: "you@example.com"
  website: "https://yoursite.com"          # omit to hide
links:                                     # omit any key to hide that icon
  linkedin: "username"
  github: "username"
  scholar: "google_scholar_user_id"
  orcid: "0000-0000-0000-0000"
  x: "username"
sections:
  - module: employment
    title: "Employment"
    type: entry
  - module: education
    title: "Education"
    type: entry
  - module: awards
    title: "Awards and Honors"
    type: columns
  # - module: publications         # comment out any section to hide it
  #   title: "Research and Publications"
  #   type: publications
```

The `sections` list controls what appears in the PDF and in what order. Comment out or remove any section you don't need.

Each section takes two keys:

- **`title`** — the heading printed in the PDF.
- **`type`** — which renderer to use:
  - `entry` — full blocks with title, organisation, date, and bullet-point details. Used for employment, education, experience, and teaching. Supports grouping multiple roles or degrees under one institution.
  - `columns` — a compact three-column layout: date on the left, title in the middle, optional right column. Used for awards, grants, service, talks, media, and mentoring.
  - `list` — a plain bulleted list. Each item in the YAML file becomes one bullet. Good for skills, hobbies, or any simple enumeration.
  - `publications` — the publications section, which handles its own internal subsections (Preprints, Conference, Journal, etc.).

---

### `employment.yaml`, `education.yaml`, `experience.yaml`, `teaching.yaml`

These all share the same structure. Each item is either a single entry or a group of entries under a shared organisation.

**Single entry** (for experience, teaching, or a one-role job):

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
    - title: "Ph.D. in Computer Science, May 2025"
      details:
        - "_Thesis:_ Your thesis title"
        - "_Advisor:_ Prof. Name"
    - title: "B.Sc. in Computer Science, May 2020"
```

For education, the date is conventionally written at the end of the title string rather than as a separate field.

---

### `awards.yaml`, `grants.yaml`, `service.yaml`, `talks.yaml`, `media.yaml`

These use a simpler three-column layout — no `cv-entry` block, just a compact line per item.

```yaml
- c1: "2024"                       # left column — date, rank, or similar
  c2: "Award or role name"         # main text
  c3: "Issuing body"               # right column — optional
  details: "Extra line of detail"  # optional
```

`c3` shows up on the right side of the same line as `c2`. `details` appears below as a secondary line. Both support the same formatting as other fields (bold, italic, links).

---

### List files (`hobbies.yaml`, etc.)

Any module declared with `type: list` uses a flat array of strings — one per bullet:

```yaml
- "Item one with **bold** text"
- "Item two with a [link](https://example.com)"
- "Plain item"
```

Alternatively, wrap them under an `items` key (same as columns files):

```yaml
items:
  - "Item one"
  - "Item two"
```

---

### `mentoring.yaml`

Same compact format as awards:

```yaml
- c1: "Institution"
  c2: "**Student Name**, degree type, brief note on their work"
```

---

### `publications.yaml`

Publications are split into named subsections (Preprints, Journal, Conference, etc.). Wrap your own name in `**double asterisks**` to bold it.

```yaml
sections:
  - heading: "Preprints"
    in_venue: false       # false = no "In" prefix; use for journals and preprints
    items:
      - authors: ["**Your Name**", "Co-author A", "Co-author B"]
        title: "Paper Title"
        venue: "arXiv / In Submission"
        year: 2025

  - heading: "Conference"
    in_venue: true        # true = renders as "In Venue, pages, location, year"
    items:
      - authors: ["**Your Name**", "Co-author"]
        title: "Paper Title"
        venue: "Proceedings of XYZ"
        pages: "1–14"       # optional
        location: "City"    # optional
        year: 2024
        award: "Best Paper" # optional — shown as a highlighted note

  - heading: "Journal"
    in_venue: false
    items:
      - authors: ["**Your Name**", "Co-author"]
        title: "Paper Title"
        venue: "Journal of XYZ"
        volume: "42"        # presence of volume triggers journal citation format
        issue: "3"          # optional
        pages: "128–145"    # optional
        year: 2024
```

---

## Formatting

`title`, `c2`, and `details` fields support a small subset of Markdown:

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
  - module: employment
    title: "Employment"
    type: entry
  # - module: grants
  #   title: "Grants and Funding"
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
  modules_en/   Any custom per-section modules (currently only publications.typ)
  fonts/        Bundled fonts
  assets/       Avatar and logos
.github/
  workflows/    CI pipelines
docker-compose.yml
```
