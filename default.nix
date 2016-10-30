{ pkgs ? import (builtins.fetchTarball
  "https://github.com/nixos/nixpkgs-channels/archive/adfcc2d9531e78bf6a9e3b56e2f4fc873cb3d87b.tar.gz") {}
}:

with pkgs;

stdenv.mkDerivation rec {
  name = "env";
  src = ./.;
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.pl" ''
    source $stdenv/setup; ln -s $env $out
  '';
  buildInputs = [
    (texlive.combine {
      inherit (texlive)
        scheme-basic
        beamer
        cm-super
        contour
        dejavu
        ec
        enumitem
        epstopdf
        etoolbox
        fancyvrb
        float
        framed
        graphics
        hyperref
        ifplatform
        latex
        latexmk
        lineno
        lm
        microtype
        minted
        ms
        pgf
        preview
        upquote
        xstring;
    })
    curl
    ghostscript
    gnumake
    pythonPackages.pygments
    unzip
    which
  ];
}
