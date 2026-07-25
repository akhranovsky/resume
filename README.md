# Resume

A reproducible, high-performance resume pipeline built with **Markdown**, **Nix Flakes**, **Pandoc**, and **Typst**.

This repository generates stylized PDF and HTML outputs directly from [`resume.md`](./resume.md) and [`style.css`](./style.css).

## Features

- **Reproducible Builds**: Powered by Nix Flakes (`flake.nix`), ensuring consistent HTML and PDF rendering across environments without manual dependency setup.
- **Typst & Pandoc Engine**: Converts Markdown directly into Typst markup for fast PDF generation.
- **Unified Design System**: Matches visual aesthetics (color palettes, font hierarchy, code badges, horizontal alignment) between HTML and PDF.
- **Automated CI/CD**:
  - **GitHub Pages**: Automatically publishes the compiled HTML resume.
  - **GitHub Releases**: Automatically packages and tags timestamped PDF, HTML, and Markdown artifacts on push to `master`.

## Usage

### Local Build

To build the HTML and PDF artifacts locally using Nix:

```shell
nix build
```

The compiled outputs will be generated in `result/resume/`:

```
result/resume/
├── resume.html
├── resume.md
└── resume.pdf
```

### Development Environment

Enter an isolated development shell containing Pandoc and Typst:

```shell
nix develop
```

## Repository Structure

- [`resume.md`](./resume.md): Primary resume content source.
- [`style.css`](./style.css): Custom CSS styles for HTML builds and web preview.
- [`flake.nix`](./flake.nix): Nix Flake build instructions for Pandoc and Typst.
- [`.github/workflows/generate.yaml`](./.github/workflows/generate.yaml): GitHub Actions workflow for building, deploying to Pages, and creating releases.

## Credits

Forked from [siph/resume-md](https://github.com/siph/resume-md) by [Chris Dawkins](https://github.com/siph).

## License

This project uses a dual license structure (see [`LICENSE`](./LICENSE)):

- **Code & Infrastructure** (`flake.nix`, `style.css`, workflows): Licensed under the **MIT License** (© Chris Dawkins & Andrey Khranovsky).
- **Personal Resume Content** ([`resume.md`](./resume.md)): Licensed under **Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)** (© Andrey Khranovsky).
