{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  # Packages that should be available in the PATH
  nativeBuildInputs = with pkgs; [
    llvm
    clang
    cmake
    pkg-config # Helps CMake/Compilers find libraries
  ];

  # Libraries that your project depends on at runtime/link-time
  buildInputs = with pkgs; [
    xorg.libX11
    # Add other X11 libs if needed (e.g., xorg.libXext, xorg.libXft)
  ];

  # Set environment variables if needed
  shellHook = ''
    echo "--- Expedition Environment Ready ---"
    echo "Clang version: $(clang --version | head -n 1)"
  '';
}
