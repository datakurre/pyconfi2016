{ pkgs ? import (builtins.fetchTarball
  "https://github.com/nixos/nixpkgs-channels/archive/adfcc2d9531e78bf6a9e3b56e2f4fc873cb3d87b.tar.gz") {}
}:

with pkgs;

let self = rec {
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out
    cat > $out/kernel.json << EOF
    $json
    EOF
  '';
  jupyter = python35Packages.notebook.override {
    postInstall = with python35Packages; ''
      mkdir -p $out/bin
      ln -s ${jupyter_core}/bin/jupyter $out/bin
      wrapProgram $out/bin/jupyter \
        --prefix PYTHONPATH : "${notebook}/lib/python3.55site-packages:$PYTHONPATH" \
        --prefix PATH : "${notebook}/bin:$PATH"
    '';
  };
  python35_with_packages = python35.buildEnv.override {
    extraLibs = with python35Packages; [
      # Kernel
      ipykernel
      ipywidgets
      # Custom packages
      hypatia
      (zodb.overrideDerivation(old: {
        patches = [
          (builtins.toFile "fix_analyze.patch" ''
--- a/src/ZODB/scripts/analyze.py
+++ b/src/ZODB/scripts/analyze.py
@@ -67,7 +67,7 @@
     fmts = "%46s %7d %8dk %5.1f%% %7.2f" # summary format
     print(fmt % ("Class Name", "Count", "TBytes", "Pct", "AvgSize"))
     print(fmt % ('-'*46, '-'*7, '-'*9, '-'*5, '-'*7))
-    typemap = rep.TYPEMAP.keys()
+    typemap = list(rep.TYPEMAP.keys())
     typemap.sort()
     cumpct = 0.0
     for t in typemap:
'')
        ];
      }))
      (buildPythonPackage {
        name = "zc.beforestorage-0.5.1";
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/07/7b/38517cacb5bfa060c709f70004522dd0acbf67acde2895ffab483f831b0c/zc.beforestorage-0.5.1.tar.gz";
          sha256 = "3d2529da826ce9845110db3d1e9c22b4f8df6662392f4a6bb27dd726b6defc88";
        };
        buildInputs = [
          zope_testing
        ];
      })
    ];
  };
  python35_kernel = stdenv.mkDerivation rec {
    name = "python35";
    buildInputs = [ python35_with_packages ];
    json = builtins.toJSON {
      argv = [ "${python35_with_packages}/bin/python3.5"
               "-m" "ipykernel" "-f" "{connection_file}" ];
      display_name = "Python 3.5";
      language = "python";
      env = { PYTHONPATH = ""; };
    };
    inherit builder;
  };
  jupyter_config_dir = stdenv.mkDerivation {
    name = "jupyter";
    buildInputs = [
      python35_kernel
    ];
    builder = writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/etc/jupyter/kernels $out/etc/jupyter/migrated
      ln -s ${python35_kernel} $out/etc/jupyter/kernels/${python35_kernel.name}
      cat > $out/etc/jupyter/jupyter_notebook_config.py << EOF
      import os
      c.KernelSpecManager.whitelist = {
        '${python35_kernel.name}'
      }
      c.NotebookApp.ip = os.environ.get('JUPYTER_NOTEBOOK_IP', 'localhost')
      EOF
    '';
  };
};

in with self;

stdenv.mkDerivation rec {
  name = "jupyter";
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
  buildInputs = [
    jupyter
    jupyter_config_dir
  ] ++ stdenv.lib.optionals stdenv.isLinux [ bash fontconfig tini ];
  shellHook = ''
    mkdir -p $PWD/.jupyter
    export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_PATH=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_DATA_DIR=$PWD/.jupyter
    export JUPYTER_RUNTIME_DIR=$PWD/.jupyter
  '';
}
