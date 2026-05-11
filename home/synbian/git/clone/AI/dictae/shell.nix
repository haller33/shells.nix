{ pkgs ? import <nixpkgs> {} }:

    pkgs.mkShell {
      packages = with pkgs; [
        uv
        nodejs_20
        git
        ffmpeg
        portaudio
        gcc
      ];

      # uv baixa wheels manylinux que esperam libstdc++/zlib em paths padrão.
      # Exponha-as via LD_LIBRARY_PATH para o intérprete Python gerenciado pelo uv.
      shellHook = ''
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.portaudio
          pkgs.libGL
        ]}:$LD_LIBRARY_PATH

        # Pede ao uv para baixar um Python independente (não usa o do Nix store)
        export UV_PYTHON_PREFERENCE=only-managed
      '';
    }
