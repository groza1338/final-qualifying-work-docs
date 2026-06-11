= Help components for title pages

== `#warning`

/// Highlights warning or placeholder content in red.
///
/// Parameters:
/// - body: The content to render as a warning.
///
/// Returns:
/// - A `text` element with red fill containing the provided `body`.
#let warning(body) = text(fill: red)[#body]
#warning[Текст предупреждения]

== `#person`

/// Creates a person record with full and abbreviated name representations.
///
/// Parameters:
/// - surname: The person's surname.
/// - first-name: The person's first name.
/// - patronymic: The person's patronymic.
/// - extras: Additional named fields to include in the resulting record.
///
/// Returns:
/// - A dictionary containing the source name parts, initials, formatted names,
///   and additional named fields.
#let person(surname, first-name, patronymic, ..extras) = {
  let first-initial = first-name.at(0)
  let patronymic-initial = patronymic.at(0)
  let initials = [#first-initial. #patronymic-initial.]
  (
    (
      surname: surname,
      first-name: first-name,
      patronymic: patronymic,
      initials: initials,
      full: [#surname #first-name #patronymic],
      short: [#surname #initials],
      reverse-short: [#initials #surname],
    )
      + extras.named()
  )
}
#person("Иванов", "Иван", "Иванович")

== `#caption-text`
/// Creates caption text with a reduced font size.
///
/// Parameters:
/// - body: The caption content.
///
/// Returns:
/// - A `text` element with a font size of 7.5pt containing the provided `body`.
#let caption-text(body) = text(size: 7.5pt)[#if body != [] [(#body)]]
#caption-text[Пример подписи]

== `#field`
/// Creates a full-width form field with an underlined value area and a centered caption below it.
///
/// Parameters:
/// - value: The field content displayed above the underline. Defaults to empty content.
/// - caption: The caption displayed below the underline. Defaults to empty content.
/// - align-value: Horizontal alignment for the field value. Defaults to `center`.
///
/// Behavior:
/// - If `value` is empty, the value area receives a fixed height of 10pt.
/// - If `value` is not empty, the value area height is determined automatically.
/// - The value is vertically aligned to the horizon and horizontally aligned using `align-value`.
/// - The caption is rendered with `caption-text` and centered below the field.
///
/// Returns:
/// - A full-width `box` containing the underlined value area and its caption.
#let field(value: [], caption: [], align-value: center, horizontal-inset: 1em) = box(width: 100%)[
  #set par(
    spacing: 0pt,
    justify: false,
  )
  #box(
    width: 100%,
    height: if value == [] { 10pt } else { auto },
    inset: (bottom: 2pt, left: horizontal-inset, right: horizontal-inset),
    stroke: (bottom: 0.5pt),
  )[
    #align(align-value + horizon)[#value]
  ]
  #v(1pt)
  #align(center)[#caption-text(caption)]
]
#field(value: [Иванов И. И.], caption: [фамилия, имя, отчество])

== `#print-date`

#let month-names = (
  "января",
  "февраля",
  "марта",
  "апреля",
  "мая",
  "июня",
  "июля",
  "августа",
  "сентября",
  "октября",
  "ноября",
  "декабря",
)

/// Creates a three-part date layout for title-page approval blocks.
///
/// Parameters:
/// - d: A `datetime` value to split into day, month, and year, or `none` to render empty placeholders.
///
/// Behavior:
/// - When `d` is a `datetime`, the function renders the day, month, and year in separate fields.
/// - When `d` is `none`, the function renders blank fields for the day and month and a placeholder year area.
///
/// Returns:
/// - A centered three-column `grid` with fields for day, month, and year.
#let print-date(d) = [
  #grid(
    align: center,
    columns: (1fr, 3fr, 2fr),
    column-gutter: 1fr,
  )[
    \"#field(value: [#if d != none { d.day() }])\"
  ][
    #field(value: [#if d != none { month-names.at(d.month() - 1) }])
  ][
    #if d != none {
      field(value: [#d.year()~г.])
    } else {
      [20 #box(width: 1fr)[#field()] г.]
    }
  ]
]
#print-date(none)
#print-date(datetime(year: 2026, month: 5, day: 25))

== `#labeled-field`
/// Creates a labeled form field arranged in a two-column grid.
///
/// Parameters:
/// - label: The label displayed in the left column.
/// - value: The field content displayed in the right column. Defaults to empty content.
/// - caption: The caption displayed below the field value. Defaults to empty content.
/// - value-width: The width of the value column. Defaults to `1fr`.
///
/// Returns:
/// - A grid containing the label and the corresponding underlined field.
#let labeled-field(label, value: [], caption: [], value-width: 1fr, ..field-parameters) = grid(
  columns: (auto, value-width),
  column-gutter: 8pt,
  align: (left, horizon),
)[
  #label
][
  #field(value: value, caption: caption, ..field-parameters.named())
]
#labeled-field(
  [Группа],
  value: [ПрИн-466],
  caption: [шифр учебной группы],
)

== `#signature-row`
/// Creates a signature row with a label, signature/date field, and name field.
///
/// Parameters:
/// - label: The label displayed in the left column.
/// - signature-date: The signature and signing date value. Defaults to empty content.
/// - name: The name value displayed in the right field. Defaults to empty content.
/// - name-caption: The caption displayed below the name field. Defaults to empty content.
///
/// Returns:
/// - A three-column grid containing the label, signature/date field, and name field.
#let signature-row(label, signature-date: [], name: [], name-caption: []) = grid(
  columns: (auto, 48mm, 1fr),
  column-gutter: 8pt,
  align: (left, horizon, horizon),
)[
  #label
][
  #field(value: signature-date, align-value: right, caption: [подпись и дата подписания])
][
  #field(value: name, caption: name-caption)
]
#signature-row(
  [Автор],
  signature-date: [20.05.2026],
  name: [Коломойцев И. С.],
  name-caption: [фамилия, инициалы],
)

== `#consultant-row`
/// Creates a consultant row for a section with signature/date and name fields.
///
/// Parameters:
/// - section: The section name displayed in the left field. Defaults to empty content.
/// - signature-date: The signature and signing date value. Defaults to empty content.
/// - name: The consultant name displayed in the right field. Defaults to empty content.
///
/// Returns:
/// - A three-column grid containing the section, signature/date field, and name field.
#let consultant-row(section: [], signature-date: [], name: []) = grid(
  columns: (1fr, 48mm, 1fr),
  column-gutter: 8pt,
  align: bottom,
)[
  #field(value: section, caption: [краткое наименование раздела])
][
  #field(value: signature-date, align-value: right, caption: [подпись и дата подписания])
][
  #field(value: name, caption: [инициалы и фамилия])
]
#consultant-row(
  section: [Экономическая часть],
  signature-date: [22.05.2026],
  name: [Соколова А. И.],
)

== `#makeRows`

/// Converts optional content into a sequence of field rows and pads it to a minimum length.
///
/// Parameters:
/// - body: `none`, a single content value, or an array of content values to render as rows.
/// - minRowsCount: The minimum number of rows to return. Defaults to `0`.
///
/// Behavior:
/// - When `body` is `none`, no source rows are added.
/// - When `body` is an array, its items are used as rows.
/// - When `body` is content, it is wrapped into a single-row sequence.
/// - Empty rows are appended until the sequence length reaches `minRowsCount`.
///
/// Returns:
/// - A sequence of content rows suitable for passing to `print-field-rows`.
#let makeRows(body, minRowsCount: 0) = {
  let rows = ()
  if body != none {
    if type(body) == array {
      rows = rows + body
    } else if type(body) == content {
      rows = rows + (body,)
    }
  }
  if rows.len() < minRowsCount {
    for i in range(minRowsCount - rows.len()) {
      rows.push([])
    }
  }
  return rows
}

#makeRows(none, minRowsCount: 5)

#makeRows(minRowsCount: 2)[Мой текст]

#makeRows(([1 строка], [2 строка]), minRowsCount: 5)

== `#print-field-rows`

/// Prints a titled sequence of underlined form fields.
///
/// Parameters:
/// - field-align: Horizontal alignment for each field value. Defaults to `left`.
/// - numberic: Whether to render row numbers before fields. Defaults to `false`.
/// - title: Optional title displayed before the field rows. Defaults to `none`.
/// - rows: Positional row content collected from the variadic arguments.
///
/// Behavior:
/// - The title is emitted first.
/// - When `numberic` is true, each row is rendered in a two-column grid with a one-based index.
/// - When `numberic` is false, each row is rendered as a full-width field.
///
/// Returns:
/// - Content containing the optional title and the rendered field rows.
#let print-field-rows(
  field-align: left,
  field-horizontal-inset: 1em,
  numberic: false,
  title: none,
  ..rows,
) = {
  title
  for (i, row) in rows.pos().enumerate() {
    if numberic {
      grid(columns: (1fr, 10fr))[
        #(i + 1))
      ][
        #field(
          value: row,
          align-value: field-align,
          horizontal-inset: field-horizontal-inset,
        )
      ]
    } else {
      field(
        value: row,
        align-value: field-align,
        horizontal-inset: field-horizontal-inset,
      )
    }
  }
}
=== Without numbers
#print-field-rows(..([Row 1], [Row 2]))
=== With numbers
#print-field-rows(numberic: true, ..([Row 1], [Row 2]))

= Explanatory note title pages
#let default-spacing = 0.8em
#let default-ministry = [Министерство науки и высшего образования Российской Федерации]
#let default-university = [
  Федеральное государственное бюджетное образовательное учреждение \
  высшего образования \
  «Волгоградский государственный технический университет»
]
#let default-faculty = [Электроники и вычислительной техники]
#let default-department = [Программное обеспечение автоматизированных систем]
#let default-city = [Волгоград]

#let person-field(person, key, default: []) = {
  if person == none {
    default
  } else {
    person.at(key, default: default)
  }
}

== `#approval-block-1`
/// Creates an approval block with a centered title, optional position field,
/// signature/name fields, and a date line.
///
/// Parameters:
/// - title: The approval block title displayed at the top.
/// - position: The position value displayed below the title. Defaults to empty content.
/// - name: The initials and surname value displayed in the right field. Defaults to empty content.
/// - date: The date displayed below the signature fields. Defaults to `none`.
/// - position-caption: The caption displayed below the position field. Defaults to empty content.
///
/// Returns:
/// - A block containing the approval title, optional position field, signature/name fields, and date.
#let approval-block-1(
  title: [your title],
  position: [],
  name: [],
  date: none,
  position-caption: [],
) = block[
  #grid(
    columns: (1fr,),
    row-gutter: 1em,
    align: center,
  )[
    #title
  ][
    #if position == [] and position-caption == [] [
      #v(1em)
    ] else [
      #field(value: position, caption: position-caption)
    ]
  ][
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 8pt,
    )[
      #field(value: [], caption: [подпись])
    ][
      #field(value: name, caption: [инициалы, фамилия])
    ]
  ][
    #block(width: 80%)[#print-date(date)]
  ]
]
#approval-block-1(
  title: [Утверждаю],
  position: [и. о. заведующего кафедрой],
  name: [Сычёв О. А.],
  date: none,
  position-caption: [должность],
)

== `#approval-block-2`

/// Creates an approval block for the task page.
///
/// Parameters:
/// - title: The approval block title displayed at the top. Defaults to "Утверждаю".
/// - position: The approver position displayed next to the title.
/// - signature-date: The signature value displayed in the left field. Defaults to empty content.
/// - name: The initials and surname displayed in the right field. Defaults to empty content.
/// - date: The date displayed below the signature fields. Defaults to `none`.
/// - position-caption: Reserved caption content. Defaults to empty content.
///
/// Returns:
/// - A grid containing the approval title, position, signature, name, and date.
#let approval-block-2(
  title: [Утверждаю],
  position: [и. о. зав кафедрой],
  signature-date: [],
  name: [],
  date: none,
  position-caption: [],
) = grid(
  columns: (1fr,),
  row-gutter: 0.35em,
  align: center,
)[
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 0.35em,
    column-gutter: 1em,
    align: center,
  )[
    #title
  ][
    #position
  ][
    #field(value: signature-date, caption: [подпись])
  ][
    #field(value: name, caption: [инициалы, фамилия])
  ]
][
  #block(width: 80%)[#print-date(date)]
]

#approval-block-2()

#import "fqw.typ": fqw-base
== `#fqw-main-title-sheet`
/// Creates the title page for a bachelor's explanatory note.
///
/// Parameters:
/// - topic: The work topic.
/// - author: The author record. Uses `full`, `group`, and optional `signature-date`.
/// - supervisor: The supervisor record. Uses `short` and optional `signature-date`.
/// - reviewer: The reviewer record. Uses `status`, `reverse-short`, and optional `date`.
/// - approver: The approving person record. Uses `status`, `reverse-short`, and optional `date`.
/// - inspector: The norm controller record. Uses `short` and optional `signature-date`.
/// - consultants: Consultant records with `section` and `person` fields.
/// - document-code: The document code.
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - faculty: The faculty name rendered in the labeled faculty field.
/// - department: The department name rendered in the labeled department field.
/// - work-kind: The work type shown between "к" and "на тему".
/// - direction: The field-of-study and profile description.
/// - city: The city shown at the bottom of the page.
/// - year: The year shown at the bottom of the page.
///
/// Returns:
/// - A configured `page` containing the full title-page layout.
#let fqw-main-title-sheet(
  // Work
  topic,
  // Persons
  author: none,
  supervisor: none,
  reviewer: none,
  approver: none,
  inspector: none,
  consultants: (
    (section: [], person: none),
    (section: [], person: none),
  ),
  // Page title parameters
  document-code: [],
  ministry: default-ministry,
  university: default-university,
  faculty: default-faculty,
  department: default-department,
  work-kind: [выпускной квалификационной работе бакалавра],
  direction: [
    09.03.04 -- Программная инженерия, \
    Разработка программно-информационных систем
  ],
  city: default-city,
  year: [#datetime.today().year()],
) = [
  #show: fqw-base
  // To display all the information on one page, wrap in a grid
  #grid(
    columns: (1fr,),
    row-gutter: 1fr,
  )[
    // University
    #align(center)[
      #ministry \
      #university
    ]
  ][
    // Faculty, Department
    #grid(
      columns: (1fr,),
      row-gutter: default-spacing,
    )[
      #labeled-field([Факультет], value: faculty)
    ][
      #labeled-field([Кафедра], value: department)
    ]
  ][
    // Reviewer, Approver
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 0.2fr,
    )[
      #approval-block-1(
        title: [Согласовано],
        position: person-field(reviewer, "status"),
        name: person-field(reviewer, "reverse-short"),
        date: person-field(reviewer, "date", default: none),
        position-caption: [должность гл. специалиста предприятия],
      )
    ][
      #approval-block-1(
        title: [Утверждаю],
        position: person-field(approver, "status"),
        name: person-field(approver, "reverse-short"),
        date: person-field(approver, "date", default: none),
      )
    ]
  ][
    // Title
    #set par(spacing: default-spacing)
    #align(center)[#strong(upper([пояснительная записка]))]
    #grid(
      columns: 3,
      column-gutter: 6pt,
    )[ к ][ #field(value: work-kind, caption: [наименование вида работы]) ][ на тему ]

    // Topic
    #print-field-rows(
      ..makeRows(topic),
    )
  ][
    // Author
    #signature-row(
      [Автор],
      name: person-field(author, "full"),
      name-caption: [фамилия, имя, отчество],
      signature-date: person-field(author, "signature-date"),
    )
    // Service information about author and direction
    #grid(
      columns: 2,
      column-gutter: default-spacing,
      row-gutter: default-spacing,
    )[Обозначение][
      #block(width: 50%)[#field(
        value: document-code,
        caption: [код документа],
      )]
    ][Группа][
      #block(width: 40%)[#field(
        value: person-field(author, "group", default: warning([ПрИн-XXX])),
        caption: [шифр группы],
      )]
    ][Направление][
      #block(width: 90%)[#field(
        value: direction,
        caption: [код и наименование направления, наименование программы (профиля)],
      )]
    ]
    // Supervisor
    #signature-row(
      [Руководитель работы],
      name: person-field(supervisor, "short"),
      name-caption: [инициалы и фамилия],
      signature-date: person-field(supervisor, "signature-date"),
    )
  ][
    // Consultants
    Консультанты по разделам:
    #for consultant in consultants [
      #block(spacing: default-spacing)[
        #consultant-row(
          section: consultant.section,
          signature-date: person-field(consultant.person, "signature-date"),
          name: person-field(consultant.person, "short"),
        )
      ]
    ]
    // Inspector
    #signature-row(
      [Нормоконтролер:],
      name: person-field(inspector, "short"),
      name-caption: [инициалы и фамилия],
      signature-date: person-field(inspector, "signature-date"),
    )
  ][
    // City, year
    #align(center)[#city #year г.]
  ]
]
#fqw-main-title-sheet

== `#fqw-main-task-title-sheet`
/// Creates the task page for a bachelor's explanatory note.
///
/// Parameters:
/// - topic: The work topic.
/// - task-from-scientific-supervisor: Initial data issued by the scientific supervisor.
/// - contents-of-explanatory-note: Rows for the explanatory note contents.
/// - graphical-meterials: Rows for the graphic material list.
/// - author: The author record. Uses `full` and `group`.
/// - supervisor: The supervisor record. Uses `short` and optional `signature-date`.
/// - approver: The approving person record. Uses `status`, `reverse-short`, and optional `date`.
/// - consultants: Consultant records with `section` and `person` fields.
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - department: The department name rendered in the labeled department field.
/// - department-code: The department code shown in the student metadata row.
/// - university-directive: The university directive date and number.
/// - work-kind: The work type shown between "к" and "на тему".
///
/// Returns:
/// - A configured `page` containing the explanatory note task layout.
#let fqw-main-task-title-sheet(
  // Work
  topic: none,
  task-from-scientific-supervisor: warning[Задание, выданное научным руководителем кафедры «ПОАС»],
  contents-of-explanatory-note: (),
  contents-min-rows: 15,
  graphical-meterials: (),
  // Persons
  author: none,
  supervisor: none,
  approver: none,
  consultants: (
    (section: [], person: none),
    (section: [], person: none),
  ),
  // Page title parameters
  ministry: default-ministry,
  university: default-university,
  department: default-department,
  department-code: [10.19],
  document-code: [],
  university-directive: (date: none, number: []),
  work-kind: [выпускную квалификационную работу бакалавра],
) = [
  #show: fqw-base
  #set page(
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 30mm,
      right: 10mm,
    ),
    header: context {
      if counter(page).get().first() > 2 {
        align(center)[#document-code]
      }
    },
    footer: context {
      if counter(page).get().first() > 2 {
        align(center)[#counter(page).display("1")]
      }
    },
  )
  #let delimiter = v(0.8em)

  // University
  #align(center)[
    #ministry \
    #university
  ]
  #delimiter

  // Department
  #labeled-field([Кафедра], value: department)
  #delimiter

  // Approver
  #v(10pt)
  #move(dx: -10pt)[
    #pad(left: 50%)[
      #approval-block-2(
        name: person-field(approver, "reverse-short"),
        position: person-field(approver, "status", default: warning([Должность])),
        date: person-field(approver, "date", default: none),
      )
    ]
  ]
  #v(7pt)
  #delimiter

  // Title
  #align(center)[
    #move(dx: -7pt)[#strong(upper([задание]))]
  ]
  #grid(
    columns: 1,
    row-gutter: default-spacing,
  )[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 6pt,
    )[на][#field(value: work-kind, caption: [наименование вида работы])]
  ][
    // Author
    #v(8pt)
    #labeled-field(
      [Студент],
      value: person-field(author, "full"),
      caption: [фамилия, имя, отчество],
    )
  ][
    // Department, Group
    #block(width: 90%)[
      #grid(
        columns: 4,
        column-gutter: default-spacing,
        row-gutter: default-spacing,
      )[ Код кафедры ][ #field(value: department-code) ][ Группа ][ #block(width: 80%)[#field(
        value: person-field(author, "group"),
      )]] ]
  ][
    // Topic
    #let topic-list = makeRows(topic, minRowsCount: 2)
    #labeled-field([Тема], value: topic-list.at(0))
    #for (i, item) in topic-list.enumerate() {
      if i != 0 {
        field(value: item)
      }
    }
  ][
  // Work approved
  #v(-8pt)
  #grid(
    columns: (auto, 3fr, auto, 1.1fr),
    column-gutter: (1.8em, 0.8em, 0pt),
  )[
    Утверждена приказом по университету
  ][
    #print-date(university-directive.date)
  ][
    №
  ][
    #field(value: university-directive.number, horizontal-inset: 0pt)
  ]
  ][
    // Date of submission of work
    #labeled-field([Срок представления готовой работы (проекта)], caption: [дата, подпись студента])
  ]
  #delimiter

  // Task from the supervisor
  #block[
    #set par(leading: 0.35em)
    #print-field-rows(
      field-horizontal-inset: 0pt,
      title: [Исходные данные для выполнения работы (проекта)],
      ..makeRows(task-from-scientific-supervisor, minRowsCount: 2),
    )
  ]
  #delimiter

  // Contents of the explanatory note
  #block[
    #set par(leading: 0.35em)
    #print-field-rows(
      field-horizontal-inset: 0pt,
      title: [Содержание основной части пояснительной записки],
      ..makeRows(contents-of-explanatory-note, minRowsCount: contents-min-rows),
    )
  ]
  #delimiter

  // Graphic material
  #print-field-rows(
    gutter: default-spacing,
    numberic: true,
    title: align(center)[Перечень графического материала],
    ..makeRows(graphical-meterials, minRowsCount: 12),
  )
  #delimiter

  // Supervisor
  #signature-row(
    [Руководитель работы],
    name: person-field(supervisor, "short"),
    name-caption: [инициалы и фамилия],
    signature-date: person-field(supervisor, "signature-date"),
  )

  // Consultants
  Консультанты по разделам:
  #for consultant in consultants [
    #block(spacing: default-spacing)[
      #consultant-row(
        section: consultant.section,
        signature-date: person-field(consultant.person, "signature-date"),
        name: person-field(consultant.person, "short"),
      )
    ]
  ]
]

== `#fqw-template-subtitle-sheet`
/// Creates the internal title page for the explanatory note document.
///
/// Parameters:
/// - topic: The work topic.
/// - sheets-count: The number of sheets shown below the document code.
/// - author: The executor record. Uses `full`, `group`, and optional `date`.
/// - supervisor: The supervisor record. Uses `short` and optional `date`.
/// - approver: The approving person record. Uses `status`, `reverse-short`, and optional `date`.
/// - inspector: The norm controller record. Uses `short` and optional `date`.
/// - document-title: The main document title.
/// - document-code: The document code.
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - department: The department name shown below the university name.
/// - city: The city shown at the bottom of the page.
/// - year: The year shown at the bottom of the page.
///
/// Returns:
/// - A configured `page` containing the explanatory note title-page layout.
#let fqw-template-subtitle-sheet(
  // Work
  topic: [],
  sheets-count: [],
  // Persons
  author: none,
  supervisor: none,
  approver: none,
  inspector: none,
  // Page title parameters
  document-title: warning([Зависит от типа документа]),
  document-code: warning([Код зависит от документа]),
  ministry: default-ministry,
  university: default-university,
  department: default-department,
  city: default-city,
  year: [#datetime.today().year()],
) = [
  #show: fqw-base
  #let bigGutter = 2em
  #let gutter = 0.8em

  #grid(columns: 1, row-gutter: 1fr)[
    // University
    #align(center)[
      #ministry \
      #university
    ]
  ][
    // Department
    #align(center)[Кафедра «#department»]
  ][
    // Approver
    #align(right)[
      #block(width: 40%)[
        #upper([Утверждаю:])

        #person-field(approver, "status")

        #grid(columns: 2)[#field()][#person-field(approver, "reverse-short")]

        #print-date(person-field(approver, "date", default: none))
      ]
    ]
  ][
    // Topic
    #align(center)[
      #for row in makeRows(topic) {
        row
        parbreak()
      }
    ]
  ][
    // Title
    #align(center)[#upper(document-title)]
    #v(default-spacing)
    // Document code
    #align(center)[#document-code]
    // Sheets count
    #align(center)[Листов #sheets-count]
  ][
    #grid(columns: (1fr, 1fr), column-gutter: 0.2fr, row-gutter: default-spacing * 2.5)[
    ][
      // Supervisor
      Руководитель работы

      #if supervisor == none {
        field()
        field()
      } else {
        field(value: person-field(supervisor, "short"))
        field()
      }

      #print-date(person-field(supervisor, "date", default: none))
    ][
      // Inspector
      Нормоконтролер

      #grid(columns: 2)[#field()][#person-field(inspector, "short")]
      #field()
      #print-date(person-field(inspector, "date", default: none))
    ][
      // Author
      Исполнитель

      #grid(columns: 2)[студент группы][#field(value: person-field(author, "group"))]
      #field(value: person-field(author, "full"))
      #print-date(person-field(author, "date", default: none))
    ]
  ][
    // City, year
    #align(center)[#city #year г.]
  ]
]

#let default-university-short = [ВолгГТУ]
#let default-university-president = [Профессору д.х.н. Навроцкому А.В.]
#let default-program = (code: [09.03.04], name: [Программная инженерия])
#let default-type-of-program = [очное]
#let default-plagiarism-detection-system = [Антиплагиат]

#let fqw-request-to-post-work(
  topic: [],
  author: none,
  author-full-gen: [],
  supervisor: none,
  restrictions: none,
  date: [],
  reason: [которые имеют действительную или потенциальную коммерческую ценность в силу неизвестности их третьим лицам.],
  university-short: default-university-short,
  university-president: default-university-president,
  faculty: default-faculty,
  program: default-program,
  type-of-program: default-type-of-program,
) = [
  #show: fqw-base
  #set page(
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 20mm,
      right: 15mm,
    ),
  )
  #set par(justify: true, first-line-indent: (amount: 1.25cm, all: true), leading: 1.06em, spacing: 1.06em)
  #grid(columns: 1, row-gutter: (4em, 1em, 2em))[
    #pad(left: 35%)[
      Ректору #university-short

      #university-president

      #labeled-field(
        [от студента],
        value: author-full-gen,
        caption: [фамилия, имя, отчество полностью],
        align-value: left,
        horizontal-inset: 0pt,
      )
      #labeled-field([Факультет], value: lower(faculty), align-value: left, horizontal-inset: 0pt)
      #labeled-field([Направление], value: [#program.code #program.name], align-value: left, horizontal-inset: 0pt)
      #labeled-field([группа], value: person-field(author, "group"), align-value: left, horizontal-inset: 0pt)
      #labeled-field([форма обучения], value: type-of-program, align-value: left, horizontal-inset: 0pt)
    ]
  ][
    #align(center)[#upper([заявление])]
  ][
    Прошу Вас разместить написанную мною выпускную квалификационную
    работу бакалавра (далее ВКР) на тему

    #align(center)[
      #set par(justify: false, first-line-indent: 0pt, spacing: 0pt)
      #for (i, row) in makeRows(topic).enumerate() {
        let caption = if i == 0 [название работы] else []
        field(value: row, caption: caption)
      }
    ]
  ][
    #let degree = if type(supervisor) == dictionary and "degree" in supervisor [
      ~#person-field(supervisor, "degree")
    ] else []
    #set par(first-line-indent: 0pt)
    #labeled-field([Научный руководитель], value: person-field(supervisor, "full") + degree)
  ][
    в файловом хранилище ВолгГТУ, расположенном по адресу _http:\/\/dump.vstu.ru_
  ][
    #if restrictions == none [
      в полном объеме.
    ] else [
      за исключением разделов (страниц)

      #let rows-of-page-info = makeRows(restrictions.page)
      #let rows-of-content-info = makeRows(restrictions.content)

      #labeled-field([номера разделов (страниц)], value: rows-of-page-info.at(0, default: []))
      #for (i, row) in rows-of-page-info.enumerate() { if i != 0 { field(value: row) } }

      #labeled-field(
        [содержащие],
        value: rows-of-content-info.at(0, default: []),
        caption: [
          указать что именно: производственные; технические: экономические: организационные сведения;
          результаты интеллектуальной деятельности в научно-технической сфере;
          сведения о способах осуществления профессиональной деятельности
        ],
        align-value: left,
      )
      #for (i, row) in rows-of-content-info.enumerate() { if i != 0 { field(value: row, align-value: left) } }
    ]
  ][
    #if restrictions != none [#reason]
  ][
    #set par(first-line-indent: 0pt)
    #pad(left: 3em)[
      #grid(columns: (12em, 12em), row-gutter: 1.5em)[
        Дата
      ][#field(value: date)][
        Подпись
      ][#field()][
        Виза руководителя ВКР
      ][#field()]
    ]
  ]
]

#let fqw-declaration-of-professional-ethics(
  topic: [],
  author: none,
  author-full-gen: [],
  supervisor: none,
  department-chair: none,
  department-chair-short-dat: [],
  date: [],
  university-short: default-university-short,
  faculty-short: [ФЭВТ],
  program: default-program,
  plagiarism-detection-system: default-plagiarism-detection-system,
) = [
  #show: fqw-base
  #set page(
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 17.5mm,
      right: 15mm,
    ),
  )
  #set par(justify: true, first-line-indent: (amount: 1.25cm, all: true), leading: 1.06em, spacing: 1.06em)
  #grid(columns: 1, row-gutter: (4em, 1em, 2em))[
    #pad(left: 50%)[
      #person-field(department-chair, "status", default: [Зав. кафедрой]) ПОАС

      #department-chair-short-dat

      #labeled-field([от студента группы], value: person-field(author, "group"), align-value: left, horizontal-inset: 0pt)
      #field(value: author-full-gen)
      #field()
      #field()
    ]
  ][
    #align(center)[#upper([заявление])]
  ][
    #align(center)[#upper([
      о соблюдении профессиональной этики \
      при написании выпускной \
      квалификационной работы
    ])]
  ][
    #set par(first-line-indent: 0pt)
    #labeled-field([Я], value: person-field(author, "full"))
    #labeled-field([студент группы], value: person-field(author, "group"), value-width: 10em)
    обучающийся по направлению #program.code «#program.name», #faculty-short
    в #university-short, заявляю, что в моей ВКР на тему:

    #align(center)[
      #set par(justify: false, first-line-indent: 0pt, spacing: 0pt)
      #for row in makeRows(topic) {
        field(value: row)
      }
    ]

    #set par(justify: true, first-line-indent: (amount: 1.25cm, all: true), leading: 1.06em, spacing: 1.06em)
    представленной в Государственную экзаменационную комиссию для публичной защиты,
    соблюдены правила профессиональной этики, не допускающие наличия плагиата,
    фальсификации данных и ложного цитирования при написании выпускных квалификационных работ.

    Все прямые заимствования из печатных и электронных источников,
    а также ранее защищенных письменных работ, кандидатских и докторских диссертаций
    имеют соответствующие ссылки.

    Я ознакомлен с действующим в ВолгГТУ порядком проведения государственной итоговой аттестации,
    положением о порядке проверки ВКР на объем заимствования.
  ][
    #set par(first-line-indent: 0pt)
    #labeled-field([_подпись студента_], value: [(#person-field(author, "short"))], align-value: right)

    #pad(left: 25em)[#labeled-field([_дата_], value: date, value-width: 6em)]
    Работа представлена для проверки уникальности текста в системе «#plagiarism-detection-system».
  ][
    #labeled-field([_дата предоставления ВКР_], value: date, value-width: 6em)

    #labeled-field([_подпись руководителя ВКР_], value: [(#person-field(supervisor, "short"))], align-value: right)
  ]
]
