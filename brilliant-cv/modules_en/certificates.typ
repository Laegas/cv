// Imports
#import "@preview/brilliant-cv:2.0.3": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)

#cvSection("Certificates", highlighted: false)

#cvEntry(
  title: [DeepLearning.AI],
  society: [Deep Learning Specialization],
  date: [2020],
  logo: image("../src/logos/deep-learning-ai.png"),
  location: "",
  description: "AB"
)