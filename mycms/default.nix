{ pkgs ? import (builtins.fetchTarball
  "https://github.com/nixos/nixpkgs-channels/archive/adfcc2d9531e78bf6a9e3b56e2f4fc873cb3d87b.tar.gz") {}
}:

with pkgs;

let self = rec {
  walkabout = pythonPackages.buildPythonPackage {
    name = "walkabout-0.10";
    src = fetchurl {
      url = "https://pypi.python.org/packages/75/2a/1784ca619581a64d533c04eae56cd92492afc461a3eaa0e8b4b073dcb199/walkabout-0.10.tar.gz";
      sha256 = "0v1dj64sas50mp177vhv29zpb95przhklh1ngvc3pa0qkw7znzgv";
    };
    propagatedBuildInputs = with pythonPackages; [
      zope_interface
    ];
  };
  pyramid_mailer = pythonPackages.buildPythonPackage {
    name = "pyramid-mailer-0.14.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/43/02/a32823750dbdee4280090843d5788cc550ab6f24f23fcabbeb7f912bf5fe/pyramid_mailer-0.14.1.tar.gz";
      sha256 = "0gz9r71sq85ifc38pdsk6pyh5b3f28fp37il5p4z9s2cx4nci36a";
    };
    propagatedBuildInputs = with pythonPackages; [
      pyramid
      repoze_sendmail
      transaction
    ];
  };
  substanced = pythonPackages.buildPythonPackage {
    name = "substanced-2016-10-23";
    src = fetchurl {
      url = "https://github.com/Pylons/substanced/archive/0f238567c99a3e5ed4e0269c36bd5cd821bd7e61.tar.gz";
      sha256 = "1br788gp9gbs9ib6833v3msw80bdim11q686ff1i9dx5mk2ckqgr";
    };
    doCheck = false;
    patchPhase = ''
      echo "graft substanced" > MANIFEST.in
    '';
    buildInputs = with pythonPackages; [
      mock
    ];
    propagatedBuildInputs = with pythonPackages; [
      ZEO
      colander
      cryptacular
      deform2
      hypatia
      pyramid
      pyramid_chameleon
      pyramid_mailer
      pyramid_zodbconn
      python_magic
      pytz
      pyyaml
      statsd
      unidecode
      venusian
      walkabout
      zodb
      zope_component
      zope_copy
      zope_deprecation
    ];
  };
};

in pythonPackages.buildPythonPackage {
  name = "mycms-0.0";
  src = ./.;
  propagatedBuildInputs = with self; [
    pythonPackages.pyramid
    pythonPackages.pyramid_debugtoolbar
    pythonPackages.pyramid_tm
    pythonPackages.waitress
    substanced
  ];
}
