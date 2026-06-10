#import "../template/title-pages.typ": (
  fqw-main-task-title-sheet, fqw-main-title-sheet, fqw-template-subtitle-sheet, person,
)

#let author = person("Гвоздков", "Сергей", "Алексеевич", group: [ПрИн-466])
#let scientific-supervisor = person("Гилка", "Вадим", "Викторович", degree: [к.т.н.])
#let approver = person("Сычёв", "Олег", "Александрович", status: [и. о. зав. кафедрой])
#let inspector = person("Кузнецова", "Агнесса", "Сергеевна")
#let university-directive = (date: datetime(year: 2025, month: 9, day: 5), number: [1203-ст])
#let submission-date = datetime(year: 2026, month: 6, day: 8)
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
  document-code: [ВКРБ-09.03.04-10.19-XX-26],
)

#main-title

#let task-title = fqw-main-task-title-sheet(
  topic: topic-of-work,
  author: author,
  approver: approver + (date: university-directive.date),
  supervisor: scientific-supervisor,
  task-from-scientific-supervisor: (
    [Задание, выданное научным руководителем кафедры «ПОАС»:],
    [разработать серверный модуль передачи данных между CRM-системой],
    [салона красоты и клиентским мини-приложением Telegram,],
    [обеспечить получение справочных данных, выполнение операций записи,],
    [а также обработку пользовательских сессий и ошибок интеграции.],
  ),
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
  sheets-count:[82],
  document-code:[ВКРБ–09.03.04–10.19–XX–XX–81],
)

#explanatory-note-title

#let technical-assignment-title = subtitle-template(
  [Техническое задание],
  sheets-count:[XX],
  document-code:[ВКРБ–09.03.04–10.19–XX–XX–91],
)

#technical-assignment-title

#let approval-sheet-title = subtitle-template(
  [Лист утверждения],
  sheets-count:[1],
  document-code:[А.В.00001-01 91 01-1-ЛУ],
)

#approval-sheet-title
