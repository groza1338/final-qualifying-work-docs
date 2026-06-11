#import "../template/title-pages.typ": (
  fqw-declaration-of-professional-ethics,
  fqw-main-task-title-sheet,
  fqw-main-title-sheet,
  fqw-request-to-post-work,
  fqw-template-subtitle-sheet,
  person,
)

#let author = person("Гвоздков", "Сергей", "Алексеевич", group: [ПрИн-466])
#let scientific-supervisor = person("Гилка", "Вадим", "Викторович", degree: [к.т.н.])
#let approver = person("Сычёв", "Олег", "Александрович", status: [и. о. зав. кафедрой])
#let inspector = person("Кузнецова", "Агнесса", "Сергеевна")
#let university-directive = (date: datetime(year: 2026, month: 2, day: 2), number: [113-ст])
#let submission-date = datetime(year: 2026, month: 6, day: 8)
#let author-full-gen = [Гвоздкова Сергея Алексеевича]
#let department-chair-short-dat = [О. А. Сычёву]
#let topic-of-work = (
  [Разработка унифицированного модуля для передачи данных],
  [между CRM-системой и мини-приложением в Telegram],
)

#let main-title = fqw-main-title-sheet(
  topic-of-work,
  author: author,
  supervisor: scientific-supervisor,
  inspector: inspector,
  approver: approver + (date: submission-date),
  document-code: [ВКРБ-09.03.04-10.19-03-26],
)

#main-title

#let task-title = fqw-main-task-title-sheet(
  topic: topic-of-work,
  author: author,
  approver: approver + (status: [и.о. зав. кафедрой]),
  supervisor: scientific-supervisor,
  task-from-scientific-supervisor: (
    [Задание, выданное научным руководителем кафедры «ПОАС»:],
    [разработать серверный модуль передачи данных между CRM-системой],
    [салона красоты и клиентским мини-приложением Telegram, обеспечить],
    [получение справочных данных и выполнение операций записи,],
    [обработку пользовательских сессий и ошибок интеграции.],
  ),
  contents-min-rows: 14,
  document-code: [ВКРБ–09.03.04–10.19–03–26–81],
  university-directive: university-directive,
)

#task-title

#let subtitle-template(document-title, sheets-count:[], document-code:[]) = fqw-template-subtitle-sheet(
  topic: topic-of-work,
  sheets-count: sheets-count,
  author: author,
  supervisor: scientific-supervisor,
  approver: approver,
  inspector: inspector,
  document-title: document-title,
  document-code: document-code,
)

#let explanatory-note-title = subtitle-template(
  [Пояснительная записка],
  sheets-count:[89],
  document-code:[ВКРБ–09.03.04–10.19–03–26–81],
)

#explanatory-note-title

#let technical-assignment-title = subtitle-template(
  [Техническое задание],
  sheets-count:[33],
  document-code:[ВКРБ–09.03.04–10.19–03–26–91],
)

#technical-assignment-title

#let system-programmers-guide-title = subtitle-template(
  [Руководство системного программиста],
  sheets-count:[12],
  document-code:[ВКРБ–09.03.04–10.19–03–26–32],
)

#system-programmers-guide-title

#let approval-sheet-title = subtitle-template(
  [Лист утверждения],
  sheets-count:[1],
  document-code:[А.В.00001-01 91 01-1-ЛУ],
)

#approval-sheet-title

#let request-to-post-work = fqw-request-to-post-work(
  topic: topic-of-work,
  author: author,
  author-full-gen: author-full-gen,
  supervisor: scientific-supervisor,
  date: submission-date.display("[day].[month].[year]"),
)

#request-to-post-work

#let declaration-of-professional-ethics = fqw-declaration-of-professional-ethics(
  topic: topic-of-work,
  author: author,
  author-full-gen: author-full-gen,
  supervisor: scientific-supervisor,
  department-chair: approver,
  department-chair-short-dat: department-chair-short-dat,
  date: submission-date.display("[day].[month].[year]"),
)

#declaration-of-professional-ethics
