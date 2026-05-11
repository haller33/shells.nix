{ pkgs ? import <nixpkgs> {} }:

let
  xorg = pkgs.xorg;
  neededLibs = with pkgs; [
    nspr glib nss openssl zlib cups
    xorg.libX11 xorg.libXext xorg.libXrender xorg.libXcomposite xorg.libXdamage xorg.libXfixes
    xorg.libXi xorg.libXrandr xorg.libXcursor xorg.libXinerama
    mesa                         # libgbm.so.1, libEGL, libGL
    libdrm                       # often needed with mesa
    xorg.libxcb                  # low-level X11 protocol (many deps)
    udev nodejs
    alsa-lib
    # Add more as you discover them (e.g., wayland, pulseaudio, etc.)
  ];
in
pkgs.mkShell {
  buildInputs = neededLibs;
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath neededLibs}:$LD_LIBRARY_PATH
    echo "Library path set. Run ./antigravity"
  '';
}
