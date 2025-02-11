// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvEntry, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)

#cvSection("Education", highlighted: false)

#cvEntry(
  title: [Master of Computer Science and Engineering],
  society: [Technical University of Denmark, Copenhagen],
  date: [2020 - 2022],
  location: [Denmark],
  logo: image("../src/logos/dtu.png"),
  description: list(
    [Thesis: Aiding Informed Critical Thinking: Mining and Visualizing the Evolution of Online Content],
    [Course: AI and algorithms study line #hBar() XXX #hBar() YYY],
  ),
)

#cvEntry(
  title: [Bachelor of ICT Engineering],
  society: [VIA University College, Horsens],
  date: [2016 - 2020],
  location: [Denmark],
  logo: image("../src/logos/via.png"),
  description: list(
    [Final project: Cloud computing for end users #hBar() Electron #hBar() React #hBar() Docker],
    [Course: Data engineering specialization #hBar() Database optimization #hBar() Data security and encryption #hBar() Data warehousing],
  ),
)
