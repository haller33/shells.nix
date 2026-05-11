{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python312
    pkgs.stdenv.cc.cc.lib
    pkgs.zlib
  ];

  shellHook = ''
    # This points Python to the shared libraries it needs
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
    
    # If you haven't created your venv yet:
    if [ ! -d ".venv" ]; then
      python -m venv .venv
    fi
    
    source .venv/bin/activate
  '';
}
