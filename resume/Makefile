TYPST_VERSION ?= 0.15.1
TYPST ?= .tools/bin/typst
PYTHON ?= python3
PHONE_NUMBER ?=
export PHONE_NUMBER

SRC := resume.typ
TEMPLATE := template-fork/coral-cv/lib.typ
STYLE := template-fork/coral-cv/style.css
DIST := dist
PDF := $(DIST)/Aryan_Arora_Resume.pdf
HTML := $(DIST)/index.html
HEADERS := $(DIST)/_headers

.PHONY: all site pdf html tools serve clean check cloudflare
.PHONY: FORCE

all: site

# Cloudflare Pages build target.
cloudflare: site

# Both artifacts are generated from the same Typst source.
site: pdf html

tools:
ifeq ($(TYPST),.tools/bin/typst)
	./scripts/bootstrap-typst.sh $(TYPST_VERSION) .tools/bin
else
	@command -v $(TYPST) >/dev/null 2>&1 || { echo "Typst not found: $(TYPST)" >&2; exit 127; }
endif

pdf: tools $(PDF)

# PHONE_NUMBER is a build input, so rebuild artifacts even when only its value changes.
$(PDF): FORCE $(SRC) $(TEMPLATE) $(STYLE)
	@mkdir -p $(DIST)
	$(TYPST) compile --input "phone=$$PHONE_NUMBER" --format pdf $(SRC) $(PDF)

html: tools $(HTML) $(HEADERS)

$(HTML): FORCE $(SRC) $(TEMPLATE) $(STYLE)
	@mkdir -p $(DIST)
	$(TYPST) compile --input "phone=$$PHONE_NUMBER" --features html --format html $(SRC) $(HTML)

$(HEADERS): _headers
	@mkdir -p $(DIST)
	cp _headers $(HEADERS)

FORCE:

serve: site
	$(PYTHON) -m http.server 8000 --directory $(DIST)

check:
	@echo "Typst version pin: $(TYPST_VERSION)"
	@echo "Typst path: $(TYPST)"
	@echo "Cloudflare output: $(DIST)"
	@bash -n scripts/bootstrap-typst.sh
	@$(MAKE) --no-print-directory -n site >/dev/null
	@test ! -e resume.html
	@grep -q -- '--features html --format html' Makefile
	@grep -q 'target() == "html"' $(TEMPLATE)
	@test -f $(STYLE)
	@grep -q 'html.style(read("style.css"))' $(TEMPLATE)
	@echo "Project checks passed."

clean:
	rm -rf $(DIST) .tools
