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

#let dateStyle(str, alignRight: true) = {
  let txt = text(size: 8pt, weight: "medium", fill: gray, style: "oblique", str)
  
  if(alignRight) {
    align(right, txt)
  } else {
    txt
  }
}

#let cvEntry(
  title: "Title",
  society: "Society",
  date: none,
  location: none,
  description: none,
  logo: none,
  interpersonalTags: (),
  techTags: (),
  oneline: false
) = {
  let boldStyle(str) = {
    text(size: 10pt, weight: "bold", str)
  }
  let locationStyle(str) = {
    align(
      right,
      text(weight: "medium", fill: gray, style: "oblique", str),
    )
  }
  let accentStyle(str) = {
    text(size: 8pt, fill: accentColor, weight: "medium", smallcaps(str))
  }
  let entryTagStyle(str) = {
    align(center, text(size: 8pt, weight: "regular", str))
  }
  let entryTagListStyle(tags, interpersonal: false) = {
    for tag in tags {
      box(
        inset: (x: 0.4em),
        outset: (y: 0.4em),
        fill: if (interpersonal) { rgb(metadata.layout.accent_color+ "80") } else { regularColors.subtlegray },
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
      boldStyle(title),
      dateStyle(date),
    )
  } else {
    (
      boldStyle(society),
      locationStyle(location),
      accentStyle(title),
      dateStyle(date),
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
    ),
  )
  
  if (description != none) {
    text(description)
  }
  entryTagListStyle(interpersonalTags, interpersonal: true)
  entryTagListStyle(techTags)

  v(3pt)
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
    [Cross-functional collaboration during a billing revamp project including RevOps and Finance teams and integrating with Stripe and HubSpot. Experience with demoing to stakeholders, collaborating and negotiating solutions with designers and PMs. Technical discussions about features in my team and improvements in office hours. Self-improvement by receiving feedback from 1:1s and performance reviews.],
    [Implemented publicly accessible calculator tool, added alternative currency exchange rates provider, wrote backend linter rules, an automated dead link checker, few data integrity checks and React hook for simpler and consistent modal implementations including forms.],
  ),
  interpersonalTags: ("Cross-functional teamwork", "Ideation sessions", "Technical discussions", "Stakeholder demos", "Office hours"),
  techTags: ("HubSpot", "Stripe", "RuboCop"),
)

#cvEntry(
  title: [Junior Software Engineer],
  society: [Capdesk],
  logo: image("img/capdesk.png"),
  date: [2020 - 2022],
  location: [Copenhagen, Denmark],
  description: list(
    [Onboarding buddy for an engineer and a designer. Regular knowledge sharing via pair programming. Outside of full-stack feature work, built Heroku ↔ Slack integration to announce releases, implemented a spellchecker in GitHub Actions using LanguageTool, added OpenAPI, wrote an ESLint rule and Git hooks for improved workflow. Went through acquisition by Carta.],
  ),
  interpersonalTags: ("Mentoring colleagues", "Pair programming"),
  techTags: ("Ruby on Rails", "React", "TypeScript", "PostgreSQL", "GitHub Actions", "Heroku", "Slack API"),
)

#cvEntry(
  title: [Junior Systems Engineer],
  society: [Systematic],
  logo: image("img/systematic.png"),
  date: [2019 - 2020],
  location: [Aarhus, Denmark],
  description: list(
    [Healthcare division, daily and restrospective rituals, build systems (Grunt & Gradle) dependency management (Nexus, NuGet, npm & Maven)],
  ),
  interpersonalTags: ("Retrospectives", "Daily standup", "Kanban"),
  techTags: ("Powershell", "C#", ".NET Core", "TeamCity CI"),
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
    [_AI and algorithms study line_: Data structures #hBar() Multi-agent systems #hBar() Deep learning #hBar() UX engineering #hBar() Computer vision],
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

#grid(
  columns: (1fr, 1fr),
  rows: auto,
  gutter: 6pt,
  cvEntry(
    title: [Boot.dev #dateStyle("- 2023", alignRight: false)],
    society: [Learn #box(baseline: 17%, image(height: 9pt, "img/go.png")) for Developers],
    logo: image("img/bootdev.png"),
  ),
  cvEntry(
    title: [DeepLearning.AI #dateStyle("- 2020", alignRight: false)],
    society: [Deep Learning Specialization],
    logo: image("img/deep-learning-ai.png"),
  )
)

#cvSection("Projects")

#cvEntry(
  title: [HabitVille],
  date: [2023 - Present],
  description: list(
    [Hobby project for tracking habits and gamifying it in a tycoon-game. Started with a web app, now working on iOS mobile app.],
  ),
  techTags: ("NextJS", "React Native", "Expo", "iOS", "AWS RDS", "BaaS - AppWrite | Convex", "NativeWind"),
  oneline: true
)

#cvSection("Skills")

#cvSkill(
  type: [Interpersonal],
  info: [Thorough & kind code reviews #hBar() Sharing critical feedback in a non-contentious way],
)

#cvSkill(
  type: [Technologies],
  info: [Ruby on Rails #hBar() React (+ Native) #hBar() TypeScript #hBar() PostgreSQL #hBar() Git #hBar() GitHub Actions #hBar() Tailwind CSS #hBar() Go #hBar() C\# #hBar() Typst],
)

#cvSkill(
  type: [Services],
  info: [Stripe #hBar() HubSpot #hBar() Heroku #hBar() Slack API #hBar() Netlify #hBar() PlanetScale #hBar() Turso],
)

#cvSkill(
  type: [Personal interests],
  info: [Piano #h(1.5pt) #box(baseline: 17%, image(height: 9pt, "img/piano.png")) #hBar() Music ◢◤ #hBar() Reading #hBar() Tech #hBar() Fitness #hBar() Wearing hoodies],
)