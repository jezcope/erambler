{ pkgs ? import <nixpkgs> { } }:

let
  my_yaspin = pkgs.python38.pkgs.buildPythonPackage rec {
    pname = "yaspin";
    version = "1.3.0";

    src = pkgs.python38.pkgs.fetchPypi {
      inherit pname version;
      sha256 =
        "cc37d35cc7f796dada6c37430b49e471ffa05d0686e6f8de36f83978b732df54";
    };

    doCheck = false;

    meta = {
      homepage = "https://github.com/pavdmyt/yaspin";
      description = "Yet Another Terminal Spinner for Python";
    };
  };
  python = pkgs.python38.withPackages (py: [
    py.python

    py.invoke
    py.rich
    my_yaspin
    py.requests

    py.Nikola
    py.markdown
    py.jinja2
    py.notebook
    py.nbconvert
    py.coconut
    py.pygments
    py.ruamel_yaml
    py.arrow

    py.aiohttp
    py.ws4py
    py.watchdog
    py.typogrify
  ]);
in pkgs.mkShell {
  buildInputs = with pkgs; [ python zeromq lessc nodejs-14_x yarn ];
}
