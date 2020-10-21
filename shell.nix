{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [python37 zeromq lessc nodejs-14_x yarn];
}
