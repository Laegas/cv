// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)

#cvSection("Professional experience", highlighted: false)

#cvEntry(
  title: [Senior Software Engineer],
  society: [Carta],
  logo: image("../src/logos/carta.png"),
  date: [2022 - Present],
  location: [Copenhagen, Denmark],
  description: list(
    [XXX],
    [YYY],
  ),
  tags: ("Tags Example here", "Dataiku", "Snowflake", "SparkSQL"),
)

#cvEntry(
  title: [Junior Software Engineer],
  society: [Capdesk],
  logo: image("../src/logos/capdesk.png"),
  date: [2020 - 2022],
  location: [Copenhagen, Denmark],
  description: list(
    [XXX],
    [YYY],
  ),
  tags: ("Tags Example here", "Dataiku", "Snowflake", "SparkSQL"),
)

#cvEntry(
  title: [Junior Systems Engineer],
  society: [Systematic],
  logo: image("../src/logos/systematic.png"),
  date: [2019 - 2020],
  location: [Aarhus, Denmark],
  description: list(
    [XXX],
    [YYY],
  ),
)
