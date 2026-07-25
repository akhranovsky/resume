{
  description = "Build your resume with markdown, pandoc, and typst";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        nativeBuildInputs = with pkgs; [
          pandoc
          typst
          liberation_ttf
        ];

        buildPhase = ''
          GEN_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
          GEN_DATE_SHORT="$(date -u +'%Y-%m-%d')"

          pandoc resume.md \
            -t html -f markdown \
            -c style.css -s \
            -V header-includes="<meta name=\"generation-date\" content=\"$GEN_DATE\"/>" \
            -o resume.html

          pandoc resume.md \
            -s \
            -t typst \
            --wrap=none \
            -M title="" \
            -V mainfont="Liberation Sans" \
            -V include-before="#set page(margin: (x: 1.5cm, top: 1.5cm, bottom: 2cm), footer: align(right, text(8pt, fill: luma(120), [Generated: $GEN_DATE_SHORT])))" \
            -V include-before="#set text(fill: rgb(\"#24292e\"), size: 10pt)" \
            -V include-before="#show link: set text(fill: rgb(\"#0366d6\"))" \
            -V include-before="#align(center)[#text(size: 22pt, weight: \"bold\", fill: rgb(\"#000000\"))[Andrey Khranovsky]]" \
            -V include-before="#v(-0.3em)" \
            -V include-before="#show regex(\"\\\\\\\\[|\\\\\\\\]\"): it => if it.text == \"\\\\[\" { \"[\" } else { \"]\" }" \
            -V include-before="#show heading.where(level: 6): it => block(width: 100%, inset: (top: 0em, bottom: 0.8em))[#align(center)[#text(size: 10.5pt, weight: \"regular\", fill: rgb(\"#666666\"))[#it.body]]]" \
            -V include-before="#show heading.where(level: 2): it => block(width: 100%, stroke: (bottom: 0.5pt + rgb(\"#e1e4e8\")), inset: (bottom: 4pt), above: 14pt, below: 8pt)[#text(fill: rgb(\"#f39\"), size: 14pt, weight: \"bold\")[#it.body]]" \
            -V include-before="#show raw.where(block: false): it => box(fill: rgb(\"#f6f8fa\"), stroke: 0.5pt + rgb(\"#e1e4e8\"), radius: 3pt, inset: (x: 3pt, y: 1.5pt))[#text(size: 8.5pt)[#it.text]]" \
            -o resume.typ

          typst compile resume.typ resume.pdf
        '';

      in with pkgs; {

        packages = {
          default = stdenvNoCC.mkDerivation {
            inherit nativeBuildInputs buildPhase;
            name = "resume_md";
            src = ./.;
            installPhase = ''
              mkdir -p $out/resume
              cp resume.* $out/resume/
              cp style.css $out/resume/
            '';
          };
        };

        checks = {
          default = stdenvNoCC.mkDerivation {
            inherit nativeBuildInputs buildPhase;
            name = "resume-md checks";
            src = ./.;
            installPhase = ''
              mkdir -p $out
            '';
          };
        };

        devShell = mkShell {
          inherit buildInputs;
        };
      });
}


