// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Projects", highlighted: false)

#cvEntry(
  title: [HabitVille],
  date: [2019 - Present],
  description: list(
    [XXX],
    [YYY],
  ),
)
