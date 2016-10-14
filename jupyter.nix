{ pkgs ? import (builtins.fetchTarball  # revision for reproducible builds
  "https://github.com/nixos/nixpkgs-channels/archive/nixos-16.03.tar.gz") {}
}:

let self = rec {
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out
    cat > $out/kernel.json << EOF
    $json
    EOF
  '';
  jupyter = pkgs.python34Packages.notebook.override {
    postInstall = with pkgs.python34Packages; ''
      mkdir -p $out/bin
      ln -s ${jupyter_core}/bin/jupyter $out/bin
      wrapProgram $out/bin/jupyter \
        --prefix PYTHONPATH : "${notebook}/lib/python3.4/site-packages:$PYTHONPATH" \
        --prefix PATH : "${notebook}/bin:$PATH"
    '';
  };
  python34 = pkgs.python34.buildEnv.override {
    extraLibs = with pkgs.python34Packages; [
      # Kernel
      ipykernel
      ipywidgets
      # Custom packages
      zodb
    ];
  };
  python34_kernel = pkgs.stdenv.mkDerivation rec {
    name = "python34";
    buildInputs = [ python34 ];
    json = builtins.toJSON {
      argv = [ "${python34}/bin/python3.4"
               "-m" "ipykernel" "-f" "{connection_file}" ];
      display_name = "Python 3.4";
      language = "python";
      env = { PYTHONPATH = ""; };
    };
    inherit builder;
  };
  jupyter_config_dir = pkgs.stdenv.mkDerivation {
    name = "jupyter";
    buildInputs = [
      python34_kernel
    ];
    builder = pkgs.writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/etc/jupyter/kernels $out/etc/jupyter/migrated
      ln -s ${python34_kernel} $out/etc/jupyter/kernels/${python34_kernel.name}
      cat > $out/etc/jupyter/jupyter_notebook_config.py << EOF
      import os
      c.KernelSpecManager.whitelist = {
        '${python34_kernel.name}'
      }
      c.NotebookApp.ip = os.environ.get('JUPYTER_NOTEBOOK_IP', 'localhost')
      EOF
    '';
  };
};
in with self;
pkgs.stdenv.mkDerivation rec {
  name = "jupyter";
  env = pkgs.buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.sh" ''
    source $pkgs.stdenv/setup; ln -s $env $out
  '';
  buildInputs = [
    jupyter
    jupyter_config_dir
  ] ++ pkgs.stdenv.lib.optionals pkgs.stdenv.isLinux [ pkgs.bash pkgs.fontconfig pkgs.tini ];
  shellHook = ''
    mkdir -p $PWD/.jupyter
    export JUPYTER_CONFIG_DIR=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_PATH=${jupyter_config_dir}/etc/jupyter
    export JUPYTER_DATA_DIR=$PWD/.jupyter
    export JUPYTER_RUNTIME_DIR=$PWD/.jupyter
  '';
}
