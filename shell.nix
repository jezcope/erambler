{ pkgs ? import (builtins.fetchTarball {
  name = "nixos-unstable-erambler";
  url = "https://github.com/nixos/nixpkgs/archive/f9d90fdbbfea5ac0349cd7d5a7025a2434dace1c.tar.gz";
  sha256 = "14lsfish1sxfbz7sqw8nzvc915j7g3asliqa45hjnpyg35cfslwf";
}) { } }:

let
  python = pkgs.python38;
  my_yaspin = python.pkgs.buildPythonPackage rec {
    pname = "yaspin";
    version = "1.3.0";
    src = python.pkgs.fetchPypi {
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
  pythonWithPackages = python.withPackages (py: [
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
  buildInputs = with pkgs; [ pythonWithPackages zeromq lessc nodejs-14_x yarn ];
}
