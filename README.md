# Aryan Arora — personal site

Personal website and technical blog about systems software, operating systems, networking, and performance.

Built with [Astro](https://astro.build/), TypeScript, Tailwind CSS, Markdown, Mermaid, and Pagefind.

## Development

Requirements: Node.js 20+ and pnpm.

```sh
corepack enable
pnpm install
pnpm dev
```

The site runs at <http://localhost:4321>.

Useful commands:

```sh
pnpm run build         # Build and check the site
pnpm preview           # Preview the production build
pnpm run lint          # Run ESLint
pnpm run format        # Format source files
pnpm run format:check  # Check formatting
```

## Content

Blog posts live in [`src/data/blog/`](src/data/blog/). Add a Markdown file with frontmatter containing at least:

```yaml
title: "Post title"
pubDatetime: 2026-01-01T00:00:00Z
description: "Short description"
tags: [systems]
draft: false
```

Post images belong in [`src/assets/images/`](src/assets/images/). Static files belong in [`public/`](public/).

## Resume

The [`resume/`](resume/) directory is a separate Typst resume project.

```sh
cd resume
make site       # Build HTML and PDF
make serve      # Preview locally
```

## Deployment

`pnpm run build` outputs the static site to `dist/`. Deploy that directory to a static host. [`wrangler.jsonc`](wrangler.jsonc) contains the Cloudflare static-assets configuration.

See [`LICENSE`](LICENSE) for licensing information.
