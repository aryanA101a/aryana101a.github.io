// HTML adapter for unmodified @preview/coral-cv:0.1.0.
// PDF rendering delegates to the vendored upstream template.
#import "../../vendor/coral-cv/lib.typ" as coral

#let accent = coral.accent

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
      _html-contact(github, href: if github == "" { none } else { "https://" + github }, label: github),
      _html-contact(linkedin, href: if linkedin == "" { none } else { "https://" + linkedin }, label: linkedin),
      _html-contact(personal-site, href: if personal-site == "" { none } else { "https://" + personal-site }),
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
        #html.elem("a", attrs: (class: "pdf-link", href: "Aryan_Arora_Resume.pdf"))[Download PDF]
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
      lang: lang,
      body,
    )
  } else {
    coral.resume(
      author: author,
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

#let _html-entry(title: "", subtitle: "", dates: "", detail: "", kind: "") = html.elem("div", attrs: (class: "entry-head " + kind))[
  #html.elem("div", attrs: (class: "entry-title"))[#title]
  #html.elem("div", attrs: (class: "entry-right"))[#dates]
  #if subtitle != "" { html.elem("div", attrs: (class: "entry-meta"))[#subtitle] }
  #if detail != "" { html.elem("div", attrs: (class: "entry-detail"))[#detail] }
]

#let edu(institution: "", dates: "", degree: "", gpa: "", location: "", consistent: false) = context {
  if target() == "html" {
    _html-entry(title: institution, subtitle: emph(degree), dates: emph(location), detail: emph(dates), kind: "education")
  } else {
    coral.edu(institution: institution, dates: dates, degree: degree, gpa: gpa, location: location, consistent: consistent)
  }
}

#let work(title: "", dates: "", company: "", location: "") = context {
  if target() == "html" {
    _html-entry(title: title, subtitle: company, dates: dates, detail: emph(location))
  } else {
    coral.work(title: title, dates: dates, company: company, location: location)
  }
}

#let project(role: "", name: "", url: "", dates: "") = context {
  if target() == "html" {
    let project-title = if url == "" {
      strong(name)
    } else {
      [#strong(name) #html.elem("span", attrs: (class: "project-source"))[#_html-link("https://" + url, "Source Code")]]
    }
    _html-entry(
      title: project-title,
      dates: if dates != "" { dates } else { emph(role) },
      kind: "project",
    )
  } else {
    // Keep project names prominent and render each source link only once.
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
