#import "@preview/brilliant-cv:3.3.0": cv-section, cv-honor
#import "../utils.typ": format-authors

#let pubs-data = yaml("../../content/publications.yaml")

#for section in pubs-data.sections {
  cv-section(section.heading)

  let in-venue = section.at("in_venue", default: false)
  for item in section.items {
    let a     = format-authors(item.at("authors", default: ()))
    let venue = item.venue
    let year  = str(item.year)

    let vp = if item.at("volume", default: none) != none {
      let p = (emph(venue) + [, #item.at("volume")],)
      if item.at("issue",    default: none) != none { p.push([(#item.issue)]) }
      if item.at("pages",    default: none) != none { p.push([:#item.pages]) }
      p.push([, #year])
      p.join([])
    } else if in-venue {
      let p = ([In ] + emph(venue),)
      if item.at("pages",    default: none) != none { p.push([, pages #item.pages]) }
      if item.at("location", default: none) != none { p.push([, #item.location]) }
      p.push([, #year])
      p.join([])
    } else {
      emph(venue) + [, #year]
    }

    let award = item.at("award", default: none)
    let issuer = if award != none { a + [. ] + vp + [. *#award*] }
                 else             { a + [. ] + vp + [.] }

    cv-honor(date: year, title: item.title, issuer: issuer)
  }
}
