// Target-aware fork of @preview/coral-cv:0.1.0.
// Upstream package: https://typst.app/universe/package/coral-cv/
// Coral CV is MIT-0 licensed.
//
// The paged branch follows Coral CV's upstream compact layout. The HTML
// branch emits semantic HTML while sharing all resume content from resume.typ.

#let paper-color = rgb("f4f3ee")
#let ink = rgb("2f2f2d")
#let muted = rgb("6f6e69")
#let accent = rgb("de5d3e")
#let rule = rgb("deddda")

#let _paged-resume(
  author: "",
  role: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  contact-lines: (),
  accent-color: accent,
  font: "New Computer Modern",
  paper: "a4",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
  body,
) = {
  set document(author: author, title: author)
  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false)
  set page(margin: 0.5in, paper: paper, fill: paper-color)
  set par(justify: true)
  set list(indent: 1.2em, body-indent: 0.35em)
  show link: underline
  show link: set text(fill: accent-color)
  show heading: set text(fill: accent-color)
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt)[#smallcaps(it.body)]
    #line(length: 100%, stroke: 0.75pt + rule)
  ]
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(weight: "bold", size: author-font-size)
    #pad(it.body)
  ]

  [= #author]
  if role != "" {
    align(author-position, text(fill: accent-color, weight: "bold")[#role])
  }
  pad(top: 0.25em)[
    #align(personal-info-position)[
      #if contact-lines.len() > 0 {
        contact-lines.join(linebreak())
      } else {
        let contact-item(value, prefix: "", link-type: "") = {
          if value == "" { none
          } else if link-type == "" { prefix + value
          } else { link(link-type + value)[#(prefix + value)] }
        }
        let items = (
          contact-item(pronouns),
          contact-item(phone),
          contact-item(location),
          contact-item(email, link-type: "mailto:"),
          contact-item(github, link-type: "https://"),
          contact-item(linkedin, link-type: "https://"),
          contact-item(personal-site, link-type: "https://"),
          contact-item(orcid, prefix: "orcid.org/", link-type: "https://orcid.org/"),
        )
        items.filter(item => item != none).join("  |  ")
      }
    ]
  ]
  body
}

#let _html-link(href, label) = html.elem("a", attrs: (href: href))[#label]

#let _html-contact(value, href: none, label: none) = {
  if value == "" {
    none
  } else if href == none {
    html.elem("span")[#value]
  } else {
    _html-link(href, if label == none { value } else { label })
  }
}

#let _html-header(
  author: "",
  role: "",
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  contact-lines: (),
) = {
  let contacts = if contact-lines.len() > 0 {
    contact-lines.map(line => html.elem("span")[#line])
  } else {
    (
      _html-contact(email, href: if email == "" { none } else { "mailto:" + email }),
      _html-contact(personal-site, href: if personal-site == "" { none } else { "https://" + personal-site }, label: personal-site),
      _html-contact(github, href: if github == "" { none } else { "https://" + github }, label: "GitHub"),
      _html-contact(linkedin, href: if linkedin == "" { none } else { "https://" + linkedin }, label: "LinkedIn"),
      _html-contact(location),
      _html-contact(pronouns),
      _html-contact(orcid, href: if orcid == "" { none } else { "https://orcid.org/" + orcid }, label: "ORCID"),
    ).filter(item => item != none)
  }

  html.elem("header", attrs: (class: "resume-header"))[
    #html.elem("h1")[#author]
    #if role != "" { html.elem("p", attrs: (class: "role"))[#role] }
    #html.elem("nav", attrs: (class: "contact"))[#contacts.join()]
  ]
}

#let _html-resume(
  author: "",
  role: "",
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  contact-lines: (),
  pdf-file: "Aryan_Arora_Resume.pdf",
  variant: "systems",
  lang: "en",
  body,
) = {
  let title = if role == "" { author } else { author + " — " + role }
  let description = if role == "" { author + " resume" } else { author + " — " + role + " resume" }

  html.elem("html", attrs: (lang: lang))[
    #html.elem("head")[
      #html.elem("meta", attrs: (charset: "utf-8"))
      #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
      #html.elem("meta", attrs: (name: "description", content: description))
      #html.elem("meta", attrs: (name: "theme-color", content: "#f4f3ee"))
      #html.elem("title")[#title]
      #html.style(read("style.css"))
    ]
    #html.elem("body")[
      #html.elem("nav", attrs: (class: "resume-variants", "aria-label": "Other resume version"))[
        #if variant == "backend" {
          _html-link("../", "View systems-focused resume →")
        } else {
          _html-link("backend/", "View backend-focused resume →")
        }
      ]
      #html.elem("main", attrs: (class: "resume"))[
        #_html-header(
          author: author,
          role: role,
          pronouns: pronouns,
          location: location,
          email: email,
          github: github,
          linkedin: linkedin,
          phone: phone,
          personal-site: personal-site,
          orcid: orcid,
          contact-lines: contact-lines,
        )
        #body
        #html.elem("a", attrs: (class: "pdf-link", href: pdf-file))[Download PDF]
      ]
    ]
  ]
}

#let resume(
  author: "",
  role: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  contact-lines: (),
  pdf-file: "Aryan_Arora_Resume.pdf",
  variant: "systems",
  accent-color: accent,
  font: "New Computer Modern",
  paper: "a4",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
  body,
) = context {
  if target() == "html" {
    _html-resume(
      author: author,
      role: role,
      pronouns: pronouns,
      location: location,
      email: email,
      github: github,
      linkedin: linkedin,
      phone: phone,
      personal-site: personal-site,
      orcid: orcid,
      contact-lines: contact-lines,
      pdf-file: pdf-file,
      variant: variant,
      lang: lang,
      body,
    )
  } else {
    _paged-resume(
      author: author,
      role: role,
      author-position: author-position,
      personal-info-position: personal-info-position,
      pronouns: pronouns,
      location: location,
      email: email,
      github: github,
      linkedin: linkedin,
      phone: phone,
      personal-site: personal-site,
      orcid: orcid,
      contact-lines: contact-lines,
      accent-color: accent-color,
      font: font,
      paper: paper,
      author-font-size: author-font-size,
      font-size: font-size,
      lang: lang,
      body,
    )
  }
}

#let generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "") = [
  #top-left #h(1fr) #top-right \
  #bottom-left #h(1fr) #bottom-right
]

#let generic-one-by-two(left: "", right: "") = [#left #h(1fr) #right]
#let dates-helper(start-date: "", end-date: "") = start-date + " " + $dash.em$ + " " + end-date
#let date-range(start: "", end: "") = dates-helper(start-date: start, end-date: end)

#let _html-entry(title: "", subtitle: "", dates: "") = html.elem("div", attrs: (class: "entry-head"))[
  #html.elem("div")[
    #html.elem("div", attrs: (class: "entry-title"))[#title]
    #if subtitle != "" { html.elem("div", attrs: (class: "entry-meta"))[#subtitle] }
  ]
  #if dates != "" { html.elem("div", attrs: (class: "dates"))[#dates] }
]

#let edu(institution: "", dates: "", degree: "", gpa: "", location: "", consistent: false) = context {
  if target() == "html" {
    let subtitle = if location == "" { degree } else { degree + " · " + location }
    _html-entry(title: institution, subtitle: subtitle, dates: dates)
  } else if consistent {
    generic-two-by-two(
      top-left: strong(institution), top-right: dates,
      bottom-left: emph(degree), bottom-right: emph(location),
    )
  } else {
    generic-two-by-two(
      top-left: strong(institution), top-right: emph(location),
      bottom-left: emph(degree), bottom-right: emph(dates),
    )
  }
}

#let work(title: "", dates: "", company: "", location: "") = context {
  if target() == "html" {
    let subtitle = if location == "" { company } else { company + " · " + location }
    _html-entry(title: title, subtitle: subtitle, dates: dates)
  } else {
    generic-two-by-two(
      top-left: strong(title), top-right: dates,
      bottom-left: company, bottom-right: emph(location),
    )
  }
}

#let project(role: "", name: "", url: "", dates: "") = context {
  if target() == "html" {
    let project-title = if url == "" {
      name
    } else {
      [#name · #_html-link("https://" + url, "Source Code")]
    }
    _html-entry(
      title: project-title,
      subtitle: role,
      dates: dates,
    )
  } else {
    generic-one-by-two(
      left: [
        #strong(name)
        #if url != "" [ #h(0.45em)#link("https://" + url)[Source Code]]
      ],
      right: if dates != "" { dates } else if role != "" { emph(role) } else { none },
    )
  }
}

#let certificates(name: "", issuer: "", url: "", date: "") = context {
  if target() == "html" {
    _html-entry(title: name, subtitle: issuer, dates: date)
  } else {
    [*#name*, #issuer#if url != "" [ (#link("https://" + url)[#url])]#h(1fr)#date]
  }
}

#let extracurriculars(activity: "", dates: "") = context {
  if target() == "html" {
    _html-entry(title: activity, dates: dates)
  } else {
    generic-one-by-two(left: strong(activity), right: dates)
  }
}
