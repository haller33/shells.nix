{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    (pkgs.python312.withPackages (ps: with ps; [ 
      tkinter 
      pip 
      setuptools
      virtualenv
    ]))
    pkgs.ffmpeg-full
    pkgs.git
  ];
}
