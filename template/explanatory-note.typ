#import "fqw.typ": fqw-indent-before-text

#let en-introduction() = [
  #heading(numbering: none)[Введение]
]

#let en-bibliography() = [
  #heading(numbering: none)[Список использованных источников]
]

#let en-header-conclusions(label: none) = [
  #heading(level: 2, numbering: none)[Выводы]
  #label
  #fqw-indent-before-text
]

#let en-bibliography(source) = [
  #pagebreak()
  #set par(justify: false)
  #bibliography(
    source,
    title: [Список использованных источников],
    style: "gost-r-7-0-100-2018-numeric-appearance.csl",
  )
]
