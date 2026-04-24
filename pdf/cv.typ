// Imports
#import "@preview/brilliant-cv:3.3.0": cv
#import "./utils.typ": render-simple-section, render-entry-section, render-list-section, render-text-section
#let metadata = toml("./metadata.toml")
#let cv-language = sys.inputs.at("language", default: none)
#let metadata = if cv-language != none {
  metadata + (language: cv-language)
} else {
  metadata
}

// Load personal info from the shared YAML source of truth
#let meta = yaml("../content/meta.yaml")

#let name-parts = meta.name.split(" ")
#let personal-last = name-parts.last()
#let personal-first = name-parts.slice(0, name-parts.len() - 1).join(" ")

#let homepage = {
  let url = meta.contact.at("website", default: none)
  if url == none { none }
  else if url.starts-with("https://") { url.slice(8) }
  else if url.starts-with("http://") { url.slice(7) }
  else { url }
}

#let affiliation = meta.at("affiliation", default: (:))

// Build personal-info and strip absent/empty fields so the template
// doesn't render stray separator bars for missing links or address.
#let personal-info = {
  let raw = (
    email:    meta.contact.at("email", default: none),
    homepage: homepage,
    github:   meta.links.at("github",   default: none),
    linkedin: meta.links.at("linkedin", default: none),
    orcid:    meta.links.at("orcid",    default: none),
    location: affiliation.at("address", default: none),
  )
  raw.pairs()
    .filter(p => p.at(1) != none and p.at(1) != "")
    .fold((:), (acc, p) => acc + ((p.at(0)): p.at(1)))
}

#let scholar = meta.links.at("scholar", default: none)
#let personal-info = if scholar != none {
  personal-info + (
    "custom-1": (
      awesomeIcon: "graduation-cap",
      text: "Google Scholar",
      link: "https://scholar.google.com/citations?user=" + scholar,
    ),
  )
} else { personal-info }

#let x-handle = meta.links.at("x", default: none)
#let personal-info = if x-handle != none {
  personal-info + (
    "custom-2": (
      awesomeIcon: "x-twitter",
      text: x-handle,
      link: "https://x.com/" + x-handle,
    ),
  )
} else { personal-info }

#let personal = (
  first_name: personal-first,
  last_name:  personal-last,
  address:    affiliation.at("address", default: ""),
  info:       personal-info,
)

#let header-quote = (
  (
    meta.at("title", default: ""),
    affiliation.at("institution", default: ""),
    affiliation.at("department", default: ""),
  )
    .filter(p => p != "")
    .join(" · ")
)

#let photo-config = meta.at("photo", default: none)
#let show-photo-pdf = (
  photo-config != none
  and photo-config.at("pdf", default: false) == true
  and photo-config.at("file", default: none) != none
)

#let metadata = (
  ..metadata,
  personal: personal,
  lang: (..metadata.lang, en: (..metadata.lang.en, header_quote: header-quote)),
  layout: (..metadata.layout, header: (..metadata.layout.header, display_profile_photo: show-photo-pdf)),
)

#show: cv.with(
  metadata,
  profile-photo: if show-photo-pdf {
    image("/content/" + photo-config.at("file"))
  } else {
    image("assets/avatar.png")
  },
  // To use custom image icons in personal.info.custom-N entries,
  // pass them here (keys must match the custom-N keys in metadata.toml):
  // custom-icons: (
  //   "custom-1": image("assets/my-icon.png"),
  // ),
)

#let _accent = {
  let named = (skyblue: rgb("#0395DE"), red: rgb("#DC3522"), nephritis: rgb("#27AE60"), concrete: rgb("#95A5A6"), darknight: rgb("#131A28"))
  let c = metadata.layout.awesome_color
  if c in named { named.at(c) } else { rgb(c) }
}
#show link: it => underline(text(fill: _accent, it))

#for section in meta.sections.filter(s => s.at("pdf", default: true) != false) {
  let module = section.module
  let title = section.at("title", default: none)
  let stype = section.type
  if stype == "text" {
    render-text-section(module, title)
  } else if stype == "entry" {
    render-entry-section(module, title)
  } else if stype == "columns" {
    render-simple-section(module, title)
  } else if stype == "list" {
    render-list-section(module, title)
  } else if stype == "publications" {
    include { "modules_en/publications.typ" }
  }
}
