{ pkgs ? import <nixpkgs> {} }:

let
  libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];
in
pkgs.mkShell {
  buildInputs = [
    pkgs.uv
    # pkgs.python312
    pkgs.gcc
    pkgs.python312Packages.cython # Added for SparseLUT
  ] ++ libraries;

  shellHook = ''
  # Point to the root directory ONLY
  export PYTHONPATH="$PYTHONPATH:$(pwd)"
  # export PYTHONPATH="$PYTHONPATH:$(pwd)"
  
  export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH"

  if [ ! -d ".venv" ]; then
    uv venv
  fi
  source .venv/bin/activate
  
  # Note: You might want to run these manually once rather than every shell start
  # uv pip install -r requirements.txt
  # uv pip install -e .
  '';
}
