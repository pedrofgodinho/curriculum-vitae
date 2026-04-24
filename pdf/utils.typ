// Shared helpers — imported by every modules_en/*.typ file

// Render Markdown-subset string to content without eval().
// Supports: **bold**, _italic_, [label](url), newlines → linebreak()
#let render-md(s) = {
  if s == none or s == "" { return [] }
  let render-inline(text) = {
    if text.len() == 0 { return [] }
    let pats  = (regex("\*\*(.*?)\*\*"), regex("_(.*?)_"), regex("\[(.*?)\]\((.*?)\)"))
    let kinds = ("bold", "italic", "link")
    let ms    = pats.map(p => text.match(p))
    let first = none
    let fkind = none
    for i in range(ms.len()) {
      let m = ms.at(i)
      if m != none and (first == none or m.start < first.start) { first = m; fkind = kinds.at(i) }
    }
    if first == none { return text }
    let before = text.slice(0, first.start)
    let inner = if fkind == "bold"   { strong(first.captures.at(0)) }
           else if fkind == "italic" { emph(first.captures.at(0)) }
           else                      { link(first.captures.at(1), first.captures.at(0)) }
    [#before#inner#render-inline(text.slice(first.end))]
  }
  s.split("\n").map(render-inline).join(linebreak())
}

#import "@preview/brilliant-cv:3.3.0": cv-section, cv-honor, cv-entry, cv-entry-start, cv-entry-continued

#let render-simple-section(module, heading) = {
  let raw = yaml("../content/" + module + ".yaml")
  let items = if type(raw) == array { raw } else { raw.items }
  let bold = if type(raw) == array { "c2" } else { raw.at("bold", default: "c2") }
  cv-section(heading)
  for item in items {
    let d = item.at("details", default: none)
    let col1 = render-md(item.c1)
    let col2 = render-md(item.c2)
    // cv-honor always bolds its title slot; use text(weight: "regular") to override
    // that when the bold should go elsewhere (or nowhere).
    cv-honor(
      date: if bold == "c1" { strong(col1) } else { col1 },
      title: if bold == "c2" { col2 } else { text(weight: "regular", col2) },
      issuer: if d != none { render-md(d) } else { "" },
    )
  }
}

#let render-text-section(module, heading) = {
  let raw = yaml("../content/" + module + ".yaml")
  let paras = if type(raw) == array { raw } else { (raw,) }
  cv-section(heading)
  paras.map(render-md).join(parbreak())
}

#let render-list-section(module, heading) = {
  let raw = yaml("../content/" + module + ".yaml")
  let items = if type(raw) == array { raw } else { raw.items }
  cv-section(heading)
  list(..items.map(render-md))
}

#let _build-desc(item) = {
  let d = item.at("details", default: none)
  if d == none { list() }
  else if type(d) == array { list(..d.map(render-md)) }
  else { list(render-md(d)) }
}

#let render-entry-section(module, heading) = {
  let data = yaml("../content/" + module + ".yaml")
  cv-section(heading)
  for item in data {
    if "entries" in item {
      if item.entries.len() == 1 {
        let e = item.entries.at(0)
        cv-entry(
          title: render-md(e.title),
          society: item.at("org", default: ""),
          date: render-md(e.at("date", default: "")),
          location: item.at("location", default: ""),
          description: _build-desc(e),
        )
      } else {
        cv-entry-start(society: item.at("org", default: ""), location: item.at("location", default: ""))
        for e in item.entries {
          cv-entry-continued(
            title: render-md(e.title),
            date: render-md(e.at("date", default: "")),
            description: _build-desc(e),
          )
        }
      }
    } else {
      cv-entry(
        title: render-md(item.at("title", default: "")),
        society: item.at("org", default: ""),
        date: render-md(item.at("date", default: "")),
        location: item.at("location", default: ""),
        description: _build-desc(item),
      )
    }
  }
}

// Format author list — bolds entries wrapped in **...**
#let format-authors(authors) = {
  let a = authors.map(s => {
    let s = s.trim()
    if s.starts-with("**") and s.ends-with("**") { strong(s.slice(2, s.len() - 2)) }
    else { s }
  })
  let n = a.len()
  if n == 0      { [] }
  else if n == 1 { a.at(0) }
  else if n == 2 { a.at(0) + [ and ] + a.at(1) }
  else           { a.slice(0, n - 1).join([, ]) + [, and ] + a.at(n - 1) }
}
