#let fqw-default-document-code = "ВКРБ-09.03.04-10.19-XX-26-81"

#let fqw-fontsize-in-em = 1.25em
#let fqw-leading = 1.06em
#let fqw-baseline = fqw-fontsize-in-em + fqw-leading

#let fqw-indent-before-text = { v(fqw-fontsize-in-em) }

#let fqw-base(body) = {
  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 30mm,
      right: 15mm,
    ),
    header: none,
    footer: none,
    numbering: none,
  )
  set text(
    lang: "ru",
    font: "Times New Roman",
    size: 14pt,
    fill: black,
    weight: "regular",
    hyphenate: false,
  )
  body
}

#let fqw-text-settings(body) = [
  #set text(
    lang: "ru",
    font: "Times New Roman",
    size: 14pt,
    fill: black,
    weight: "regular",
    hyphenate: false,
  )
  #set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
    leading: fqw-leading,
    spacing: 1.1em,
  )
  #body
]

#let fqw-document(body, document-code: fqw-default-document-code) = [
  #show: fqw-base
  #show: fqw-text-settings

  // page settings
  #set page(
    header: align(center)[#document-code],
    footer: context align(center)[#counter(page).display("1")],
  )

  // headers settings
  #show heading: it => block(
    spacing: fqw-baseline,
  )[
    #if it.level == 1 {
      counter(figure.where(kind: image)).update(0)
      counter("fqw-table").update(0)
    }
    #show: fqw-text-settings
    #set par()
    #par[
      #if it.numbering != none [
        #counter(heading).display(it.numbering) #h(0.5em)
      ]
      #it.body
    ]
  ]

  #show math.equation: it => {
    if it.block {
      block(
        spacing: fqw-baseline,
      )[
        #it
      ]
    } else {
      it
    }
  }

  // lists markers
  #set list(marker: [--], indent: 1.25cm)
  #set enum(numbering: "1.", indent: 1.25cm)

  // numbering
  #set heading(numbering: "1.1")
  #set enum(numbering: "1.")
  #set math.equation(numbering: n => {
    numbering(
      "(1.1)",
      counter(heading).get().first(),
      n,
    )
  })
  #show figure.where(kind: image): set figure(
    supplement: [Рисунок],
    numbering: n => numbering(
      "1.1",
      counter(heading).get().first(),
      n,
    ),
  )

  #set figure.caption(
    separator: [ -- ],
  )

  // default color links
  #show link: it => text(fill: black)[#it]

  #body
]

#let fqw-header-abstract() = [
  #heading(level: 1, numbering: none, outlined: false)[Аннотация]
  #fqw-indent-before-text
]

#let fqw-outline() = [
  #heading(numbering: none, outlined: false)[Содержание]
  #set outline.entry(fill: none)
  #outline(title: none, depth: 3, indent: 0pt)
  #pagebreak()
]

#let fqw-introduction(label: none, heading-counter: none) = [
  #heading(numbering: none)[Введение]
  #fqw-indent-before-text
  #if label != none {
    label
  }
  #if heading-counter != none {
    counter(heading).update(heading-counter)
  }
]

#let fqw-equation-list(equations) = {
  show math.equation: it => {
    block(
      spacing: 0.5em,
    )[
      #it
    ]
  }
  block(spacing: fqw-baseline)[
    #for (i, item) in equations.enumerate() {
      let is-last = i == equations.len() - 1
      let formula = if type(item) == array {
        item.at(0)
      } else {
        item
      }
      let label = if type(item) == array and item.len() > 1 {
        item.at(1)
      } else {
        none
      }

      let body = [
        #formula#if not is-last [,]
      ]

      if label == none {
        math.equation(
          numbering: none,
          block: true,
        )[
          #body
        ]
      } else {
        let eq = math.equation(
          block: true,
        )[
          #body
        ]
        [#eq #label]
      }
    }
  ]
}

#let fqw-where(items) = block[
  #set par(first-line-indent: 0pt)
  #pad(left: 1.25cm, [
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
    )[
      где
    ][
      #for (i, item) in items.enumerate() [
        #item.at(0) -- #item.at(1)#if i == items.len() - 1 [.] else [;] \
      ]
    ]
  ])

]

#let fqw-eq-ref(label) = context numbering(
  "1.1",
  counter(heading).at(label).first(),
  counter(math.equation).at(label).first(),
)

#let fqw-section-ref(label) = context {
  let counts = counter(heading).at(label)
  let last-nonzero = 0
  for (i, v) in counts.enumerate() {
    if v != 0 { last-nonzero = i }
  }
  counts.slice(0, last-nonzero + 1).map(str).join(".")
}

#let fqw-appendix-letter(number) = {
  let letters = (
    "А",
    "Б",
    "В",
    "Г",
    "Д",
    "Е",
    "Ж",
    "И",
    "К",
    "Л",
    "М",
    "Н",
    "П",
    "Р",
    "С",
    "Т",
    "У",
    "Ф",
    "Х",
    "Ц",
    "Ш",
    "Щ",
    "Э",
    "Ю",
    "Я",
  )
  letters.at(number - 1)
}

#let fqw-in-appendix = state("fqw-in-appendix", false)

#let fqw-subappendix-number() = {
  fqw-appendix-letter(counter("fqw-appendix").get().first()) + "." + str(counter("fqw-subappendix").get().first())
}

#let fqw-smart-figure-numbering(n) = context {
  if fqw-in-appendix.get() {
    fqw-subappendix-number() + "." + str(n)
  } else {
    numbering("1.1", counter(heading).get().first(), n)
  }
}

#let fqw-figure-ref(label) = context {
  if fqw-in-appendix.at(label) {
    let app = counter("fqw-appendix").at(label).first()
    let sub = counter("fqw-subappendix").at(label).first()
    let fig = counter(figure.where(kind: image)).at(label).first()
    fqw-appendix-letter(app) + "." + str(sub) + "." + str(fig)
  } else {
    numbering("1.1", counter(heading).at(label).first(), counter(figure.where(kind: image)).at(label).first())
  }
}

#let fqw-table-number() = context {
  if fqw-in-appendix.get() {
    fqw-subappendix-number() + "." + str(counter("fqw-table").get().first())
  } else {
    numbering("1.1", counter(heading).get().first(), counter("fqw-table").get().first())
  }
}

#let fqw-table-ref(label) = context {
  if fqw-in-appendix.at(label) {
    let app = counter("fqw-appendix").at(label).first()
    let sub = counter("fqw-subappendix").at(label).first()
    let tbl = counter("fqw-table").at(label).first()
    fqw-appendix-letter(app) + "." + str(sub) + "." + str(tbl)
  } else {
    numbering("1.1", counter(heading).at(label).first(), counter("fqw-table").at(label).first())
  }
}

#let fqw-figure(body, caption, numbering: auto) = {
  let body = [
    #align(center)[#body]
  ]

  figure(
    kind: image,
    supplement: [Рисунок],
    caption: caption,
    numbering: if numbering != auto { numbering } else { n => fqw-smart-figure-numbering(n) },
  )[
    #body
  ]
}

#let fqw-placeholder-figure(caption) = fqw-figure(
  rect(width: 120mm, height: 45mm, stroke: 0.8pt)[
    #align(center + horizon)[Место для диаграммы]
  ],
  caption,
)

#let fqw-table(
  caption,
  columns: 1,
  header: (),
  rows: (),
  align: auto,
  header-align: center + horizon,
  inset: 6pt,
  label: none,
  caption-gap: 0.5em,
) = block(spacing: fqw-baseline)[
  #set par(first-line-indent: 0pt)
  #counter("fqw-table").step()
  #set text(hyphenate: true)

  #let table-label = if label == none {
    label("fqw-table-" + str(counter("fqw-table").get().first()))
  } else {
    label
  }
  #let column-count = if type(columns) == int {
    columns
  } else {
    columns.len()
  }

  #block(
    sticky: true,
    spacing: 0pt,
  )[
    #set par(
      first-line-indent: 0pt,
      leading: 0em,
    )
    Таблица #fqw-table-number() -- #caption
    #table-label
  ]

  #let repeated-header = (
    (
      table.cell(
        colspan: column-count,
        inset: (top: 0pt, bottom: caption-gap, left: 0pt, right: 0pt),
        stroke: none,
      )[
        #context if here().page() != query(table-label).first().location().page() [
          Продолжение таблицы #fqw-table-number()
        ]
      ],
    )
      + header
  )

  #show table.cell.where(y: 0): set table.cell(align: header-align)
  #show table.cell.where(y: 1): set table.cell(align: header-align)

  #table(
    columns: columns,
    align: align,
    inset: inset,
    table.header(..repeated-header),
    ..rows,
  )

]

#let fqw-landscape(body, document-code: none) = page(
  flipped: true,
  header: if document-code == none {
    none
  } else {
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [#document-code], context counter(page).display("1"),
    )
  },
)[#body]

#let fqw-appendix(title) = [
  #pagebreak()
  #counter("fqw-appendix").step()
  #counter("fqw-subappendix").update(0)
  #context {
    let number = fqw-appendix-letter(counter("fqw-appendix").get().first())

    show heading: it => []
    heading(numbering: none, outlined: true)[Приложение #number - #title]

    v(1fr)
    align(center)[
      #set par(justify: false, first-line-indent: 0pt)
      Приложение #number
      #linebreak()
      #title
    ]
    v(1fr)
  }
]

#let fqw-appendix-group(number: 1) = [
  #counter("fqw-appendix").update(number)
  #counter("fqw-subappendix").update(0)
  #fqw-in-appendix.update(true)
]

#let fqw-subappendix(title, label: none, title-label: none, outlined: true, next-paragraph: false) = [
  #pagebreak()
  #counter("fqw-subappendix").step()
  #counter("fqw-subappendix-section").update(0)
  #fqw-in-appendix.update(true)
  // Override heading spacing: 1 line after "Приложение Б.X", 0pt after title
  // (the document controls spacing after the title via fqw-indent-before-text)
  #show heading: it => block(
    spacing: fqw-baseline,
  )[
    #if it.level == 1 {
      counter(figure.where(kind: image)).update(0)
      counter("fqw-table").update(0)
    }
    #show: fqw-text-settings
    #set par()
    #par[#it.body]
    #if next-paragraph { fqw-indent-before-text }
  ]

  #align(right)[
    #context {
      heading(numbering: none, outlined: outlined)[Приложение #fqw-subappendix-number()]
    }
    #if label != none {
      label
    }
  ]

  #align(center)[
    #heading(level: 2, numbering: none, outlined: outlined)[#title]
    #if title-label != none {
      title-label
    }
  ]

]

#let fqw-subappendix-section(title, label: none, outlined: true) = [
  #counter("fqw-subappendix-section").step()
  #counter("fqw-subappendix-subsection").update(0)
  #context {
    let section-number = fqw-subappendix-number() + "." + str(counter("fqw-subappendix-section").get().first())
    heading(level: 2, numbering: none, outlined: outlined)[
      #section-number
      #h(0.5em)
      #title
    ]
  }
  #if label != none {
    label
  }
]

#let fqw-subappendix-subsection(title, label: none, outlined: false) = [
  #counter("fqw-subappendix-subsection").step()
  #context {
    let subsection-number = (
      fqw-subappendix-number()
        + "."
        + str(counter("fqw-subappendix-section").get().first())
        + "."
        + str(counter("fqw-subappendix-subsection").get().first())
    )
    heading(level: 3, numbering: none, outlined: outlined)[
      #subsection-number
      #h(0.5em)
      #title
    ]
  }
  #if label != none {
    label
  }
]

#let document-title(title) = [
  #align(left)[#title]
]
