#import "@preview/fontawesome:0.2.1": *
#let metadata = toml("./metadata.toml")

#let personalInfo = metadata.personal.info
#let firstName = metadata.personal.first_name
#let lastName = metadata.personal.last_name
#let regularFont = metadata.layout.fonts.regular_font
#let headerFont = metadata.layout.fonts.header_font
#let accentColor = rgb(metadata.layout.accent_color)
#let headerQuote = metadata.lang.header_quote 
#let footer = metadata.lang.cv_footer 
#let regularColors = (
  subtlegray: rgb("#ededee"),
  lightgray: rgb("#343a40"),
  darkgray: rgb("#212529"),
)

// Functions
#let hBar() = [#h(2pt) | #h(2pt)]

#let cvFooter() = {
  // Styles
  let footerStyle(str) = {
    text(size: 8pt, fill: rgb("#999999"), smallcaps(str))
  }

  return place(bottom+left, dy: -30pt, table(
    columns: (1fr, auto),
    inset: 0pt,
    stroke: none,
    footerStyle([#firstName #lastName]), footerStyle(footer),
  ))
}

#let makeHeaderInfo() = {
  let iconsArgs = (size: 13pt)
  let personalInfoIcons = (
    phone: fa-phone(..iconsArgs),
    email: fa-envelope(..iconsArgs),
    linkedin: fa-linkedin(..iconsArgs),
    homepage: fa-pager(..iconsArgs),
    github: fa-square-github(..iconsArgs),
  )
  let n = 1
  for (k, v) in personalInfo { 
    if v != "" {
      box({
        // Adds icons
        box(move(dy: 1.5pt, personalInfoIcons.at(k)))
        h(5pt)
        // Adds hyperlinks
        if k == "email" {
          link("mailto:" + v)[#v]
        } else if k == "phone" {
          link("tel:" + v)[#v]
        } else if k == "linkedin" {
          link("https://www.linkedin.com/in/" + v)[#v]
        } else if k == "github" {
          link("https://github.com/" + v)[#v]
        } else if k == "homepage" {
          link("https://" + v)[#v]
        } else {
          v
        }
      })
    }
    // Adds hBar
    if n != personalInfo.len() {
      [#h(5pt) #box(height: 15pt, baseline: 25%, line(stroke: 0.9pt + accentColor, angle: 90deg, length: 100%)) #h(5pt)]
    }
    n = n + 1
  }
}

#let headerNameStyle(str) = {
  text(
    font: headerFont,
    size: 32pt,
    weight: "regular",
    str,
  )
}

#let headerInfoStyle(str) = {
  text(size: 10pt, fill: accentColor, str)
}

#let headerQuoteStyle(str) = {
  text(size: 10pt, weight: "medium", style: "italic", fill: accentColor, str)
}

#let makeHeaderNameSection() = align(center, table(
  columns: 1fr,
  inset: 0pt,
  stroke: none,
  row-gutter: (6mm, 4mm),
  [#headerNameStyle(firstName) #h(5pt) #headerNameStyle(lastName)],
  [#headerInfoStyle(makeHeaderInfo())],
  [#headerQuoteStyle(headerQuote)],
))

/// Add the title of a section.
/// - title (str): The title of the section.
/// - highlighted (bool): Whether the first n letters will be highlighted in accent color.
/// - letters (int): The number of first letters of the title to highlight.
/// -> content
#let cvSection(
  title,
  highlighted: true,
  letters: 3,
  beforeSectionSkip: 5pt
) = {
  let highlightText = title.slice(0, letters)
  let normalText = title.slice(letters)
  let sectionTitleStyle(str, color: black) = {
    text(size: 16pt, weight: "bold", fill: color, str)
  }

  v(beforeSectionSkip)
  if highlighted {
    sectionTitleStyle(highlightText, color: accentColor)
    sectionTitleStyle(normalText, color: black)
  } else {
    sectionTitleStyle(title, color: black)
  }

  h(2pt)
  box(width: 1fr, line(stroke: 0.9pt, length: 100%))
}

#let cvEntry(
  title: "Title",
  society: "Society",
  date: "Date",
  location: "",
  description: none,
  logo: none,
  tags: (),
  oneline: false
) = {
  let entryA1Style(str) = {
    text(size: 10pt, weight: "bold", str)
  }
  let entryA2Style(str) = {
    align(
      right,
      text(weight: "medium", fill: gray, style: "oblique", str),
    )
  }
  let entryB1Style(str) = {
    text(size: 8pt, fill: accentColor, weight: "medium", smallcaps(str))
  }
  let entryB2Style(str) = {
    align(
      right,
      text(size: 8pt, weight: "medium", fill: gray, style: "oblique", str),
    )
  }
  let entryTagStyle(str) = {
    align(center, text(size: 8pt, weight: "regular", str))
  }
  let entryTagListStyle(tags) = {
    for tag in tags {
      box(
        inset: (x: 0.4em),
        outset: (y: 0.4em),
        fill: regularColors.subtlegray,
        radius: 3pt,
        entryTagStyle(tag),
      )
      h(5pt)
    }
  }

  let dynamicLogo(img) = context {    
    if (img == none) {
      return
    }
    
    let size = measure(img)
    let ratio = size.width / size.height
    let maxHeight = 20pt
    let imageSize = (height: maxHeight)
    let maxRatio = 3
    if ratio > maxRatio {
      imageSize = (width: maxRatio * maxHeight)
    }
    set image(..imageSize, fit: "contain")
    img
  }

  let content = if (oneline) {
    (
      {entryA1Style(title)},
      {entryA2Style(date)},
    )
  } else {
    (
      {entryA1Style(society)},
      {entryA2Style(location)},
      entryB1Style(title),
      entryB2Style(date),
    )
  }

  table(
    columns: (auto , 1fr),
    inset: 0pt,
    stroke: none,
    align: horizon,
    column-gutter:if logo == none { 0pt } else { 4pt },
    dynamicLogo(logo),
    table(
      columns: (1fr, auto),
      inset: 0pt,
      stroke: none,
      row-gutter: 6pt,
      align: auto,
      ..content
      // {entryA1Style(society)},
      // {if(oneline) { [] } else { entryA2Style(location) }},
      // {if(oneline) { [] } else { entryB1Style(title) }},
      // {entryB2Style(date)},
    ),
  )
  
  if (description != none) {
    text(description)
  }
  entryTagListStyle(tags)
}

#let cvSkill(type: "Type", info: "Info") = {
  let skillTypeStyle(str) = {
    align(horizon + right, text(size: 10pt, weight: "bold", str))
  }
  let skillInfoStyle(str) = {
    text(str)
  }

  table(
    columns: (16%, 1fr),
    inset: 0pt,
    column-gutter: 10pt,
    stroke: none,
    skillTypeStyle(type), skillInfoStyle(info),
  )
  v(-2pt)
}

// Page setup
#set page(
  paper: "a4",
  margin: (x: 30pt, y: 40pt),
  background: place(top+left, rect(height: 100%, width: 100%, fill: gradient.linear(..color.map.flare, angle: 60deg))[
    #place(top+left, dx: 15pt, dy: 15pt, rect(height: 100%-30pt, width: 100%-30pt, fill: white, radius: 10pt))
  ]),
  footer: cvFooter()
)
// Styling setup
#set text(font: "Source Sans 3", weight: "regular", size: 9pt)

// Document content
#makeHeaderNameSection()

#cvSection("Professional experience")

#cvEntry(
  title: [Senior Software Engineer],
  society: [Carta],
  logo: image("img/carta.svg"),
  date: [2022 - Present],
  location: [Copenhagen, Denmark],
  description: list(
    [XXX],
    [YYY],
  ),
  tags: ("CMR - HubSpot", "Billing - Stripe"),
)

// Numerous CRUD-like features
// Billing refactoring involving Stripe and HubSpot integrations
// Public page calculator
// Alternative currency exchange rates source
// Git hooks for improved workflow

#cvEntry(
  title: [Junior Software Engineer],
  society: [Capdesk],
  logo: image("img/capdesk.png"),
  date: [2020 - 2022],
  location: [Copenhagen, Denmark],
  description: list(
    [XXX],
    [YYY],
  ),
  tags: ("Ruby on Rails", "React", "AngularJS", "PostgreSQL"),
)

// Acquired by Carta

#cvEntry(
  title: [Junior Systems Engineer],
  society: [Systematic],
  logo: image("img/systematic.png"),
  date: [2019 - 2020],
  location: [Aarhus, Denmark],
  description: list(
    [XXX],
    [YYY],
  ),
  tags: ("Powershell", ""),
)

#cvSection("Education")

#cvEntry(
  title: [Master of Computer Science and Engineering],
  society: [Technical University of Denmark, Copenhagen],
  date: [2020 - 2022],
  location: [Denmark],
  logo: image("img/dtu.png"),
  description: list(
    // TODO link to thesis
    [_Thesis_: Aiding Informed Critical Thinking: Mining and Visualizing the Evolution of Online Content],
    [_AI and algorithms study line_: XXX #hBar() YYY],
  ),
)

#cvEntry(
  title: [Bachelor of ICT Engineering],
  society: [VIA University College, Horsens],
  date: [2016 - 2020],
  location: [Denmark],
  logo: image("img/via.png"),
  description: list(
    // TODO: link to project
    [_Final project_: Cloud computing for end users #hBar() Electron #hBar() React #hBar() Docker],
    [_Data engineering specialization_: Database optimization #hBar() Data security and encryption #hBar() Data warehousing],
  ),
)

#cvSection("Certificates")

#cvEntry(
  title: [Boot.dev],
  society: [Learn #box(baseline: 17%, image(height: 9pt, "img/go.png")) for Developers],
  date: [2023],
  logo: image("img/bootdev.png"),
  location: ""
)

#cvEntry(
  title: [DeepLearning.AI],
  society: [Deep Learning Specialization],
  date: [2020],
  logo: image("img/deep-learning-ai.png"),
  location: ""
)

#cvSection("Projects")

#cvEntry(
  title: [HabitVille],
  date: [2023 - Present],
  description: list(
    [Hobby project for tracking habits and gamifying it in a tycoon-game],
  ),
  tags: ("NextJS", "React Native", "Expo", "BaaS - AppWrite | Convex"),
  oneline: true
)

#cvSection("Skills")

#cvSkill(
  type: [Interpersonal],
  info: [Thorough & kind code reviews #hBar() Critical feedback #hBar() Critical feedback],
)

#cvSkill(
  type: [Technologies],
  info: [Ruby on Rails #hBar() React #hBar() PostgreSQL #hBar() Git #hBar() GitHub Actions],
)

#cvSkill(
  type: [Services],
  info: [Stripe #hBar() HubSpot #hBar() Heroku],
)

#cvSkill(
  type: [Personal interests],
  info: [Piano #h(1.5pt) #box(baseline: 17%, image(height: 9pt, "img/piano.png")) #hBar() Reading #hBar() Wearing hoodies],
)