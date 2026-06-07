TYPST ?= typst

DOCS := explanatory-note technical-assignment system-programmers-guide

.PHONY: all clean $(DOCS) watch-explanatory-note watch-technical-assignment watch-system-programmers-guide

all: $(DOCS)

$(DOCS): build
	$(TYPST) compile --root . docs/$@.typ build/$@.pdf

build:
	mkdir -p build

watch-technical-assignment: build
	$(TYPST) watch --root . docs/technical-assignment.typ build/technical-assignment.pdf

watch-system-programmers-guide: build
	$(TYPST) watch --root . docs/system-programmers-guide.typ build/system-programmers-guide.pdf

watch-explanatory-note: build
	$(TYPST) watch --root . docs/explanatory-note.typ build/explanatory-note.pdf

clean:
	rm -f build/*.pdf
