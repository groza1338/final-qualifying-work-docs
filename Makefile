TYPST ?= typst
PLANTUML ?= plantuml

DOCS := explanatory-note technical-assignment system-programmers-guide
EXPLANATORY_NOTE_DIAGRAMS := \
	assets/images/explanatory-note/system-context.puml \
	assets/images/explanatory-note/backend-architecture.puml \
	assets/images/explanatory-note/data-transfer-flow.puml \
	assets/images/explanatory-note/use-case.puml \
	assets/images/explanatory-note/class-diagram.puml \
	assets/images/explanatory-note/database-er.puml \
	assets/images/technical-assignment/use-case.puml

.PHONY: all clean diagrams $(DOCS) watch-explanatory-note watch-technical-assignment watch-system-programmers-guide

all: $(DOCS)

$(DOCS): build
	$(TYPST) compile --root . docs/$@.typ build/$@.pdf

build:
	mkdir -p build

diagrams:
	$(PLANTUML) -tsvg $(EXPLANATORY_NOTE_DIAGRAMS)

watch-technical-assignment: build
	$(TYPST) watch --root . docs/technical-assignment.typ build/technical-assignment.pdf

watch-system-programmers-guide: build
	$(TYPST) watch --root . docs/system-programmers-guide.typ build/system-programmers-guide.pdf

watch-explanatory-note: build
	$(TYPST) watch --root . docs/explanatory-note.typ build/explanatory-note.pdf

clean:
	rm -f build/*.pdf
