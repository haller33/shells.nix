{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python312
    pkgs.stdenv.cc.cc.lib
    pkgs.zlib
    pkgs.libgcc
    pkgs.ffmpeg
    # Adiciona suporte a CUDA se você estiver usando NVIDIA
    pkgs.cudaPackages.cudatoolkit 
    pkgs.linuxPackages.nvidia_x11
  ];

  shellHook = ''
    # Inclui os drivers do sistema e as libs do CUDA no Path
    export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:${pkgs.lib.makeLibraryPath [ 
      pkgs.stdenv.cc.cc.lib 
      pkgs.zlib 
      pkgs.libgcc
      pkgs.ffmpeg
      pkgs.cudaPackages.cudatoolkit
      pkgs.linuxPackages.nvidia_x11
    ]}:$LD_LIBRARY_PATH"

    # Ativa o venv se existir
    if [ -d .venv ]; then
      source .venv/bin/activate
    fi
    
    echo "--- NixOS GPU-Enabled Dev Environment ---"
    echo "NVIDIA Drivers & CUDA Toolkit carregados."
    
    # Teste rápido para ver se a GPU é detectada
    if command -v nvidia-smi >/dev/null; then
       echo "GPU Detectada: $(nvidia-smi --query-gpu=name --format=csv,noheader)"
    fi
  '';
}
