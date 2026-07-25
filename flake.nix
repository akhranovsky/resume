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
            -V mainfont="Liberation Sans" \
            -V include-before="#set page(footer: align(right, text(8pt, fill: luma(120), [Generated: $GEN_DATE_SHORT])))" \
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


