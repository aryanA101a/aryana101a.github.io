# hosted-resume


## Cloudflare Pages


Use:

```text
Framework preset:       None
Build command:          make cloudflare
Build output directory: dist
Root directory:         /
Production branch:      main
```


On every deployment Cloudflare will:

1. bootstrap the pinned Typst compiler;
2. compile `resume.typ` to `dist/resume.pdf`;
3. compile the same `resume.typ` to `dist/index.html` using Typst's HTML target;
4. publish `dist/`.

## Local build

```sh
make site
```

The phone number is supplied at build time through the `PHONE_NUMBER`
environment variable. It is included in the PDF and intentionally omitted
from the hosted HTML resume:

```sh
PHONE_NUMBER="(+91) 1234567890" make site
```

Set the same variable in the Cloudflare Pages build environment if the PDF
should include a phone number. Leave it unset to omit the number from both
artifacts.

By default this downloads Typst 0.15.1 into `.tools/bin/typst`. To use an already-installed Typst instead:

```sh
make TYPST=typst site
```

Preview locally:

```sh
make serve
```

Then open `http://localhost:8000`.

## Targets

```sh
make pdf          # resume.typ -> dist/resume.pdf
make html         # resume.typ -> dist/index.html
make site         # build both
make cloudflare   # Cloudflare Pages build target
make serve        # build + serve dist/ locally
make check        # project sanity checks
make clean        # remove generated output and downloaded tools
```

## Theme

Slate + Blue:

- background: `#F8FAFC`
- text: `#111827`
- muted text: `#64748B`
- accent: `#2563EB`
- dividers: `#E2E8F0`

## Typst HTML note

Typst HTML export is currently experimental and requires the `html` compiler feature. This project deliberately uses it so the hosted resume and PDF cannot drift apart. The template uses target-aware rendering instead of trying to force the paged A4 layout directly into the browser.

## Coral CV

The paged layout is derived from `@preview/coral-cv:0.1.0` and vendored locally. The upstream MIT-0 license is preserved in `vendor/coral-cv/LICENSE`.
