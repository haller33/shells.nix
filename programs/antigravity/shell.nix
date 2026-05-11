{ pkgs ? import <nixpkgs> {} }:

let
  xorg = pkgs.xorg;
  neededLibs = with pkgs; [
    nspr glib nss openssl zlib cups
    xorg.libX11 xorg.libXext xorg.libXrender xorg.libXcomposite xorg.libXdamage xorg.libXfixes
    xorg.libXi xorg.libXrandr xorg.libXcursor xorg.libXinerama
    mesa
    libdrm
    xorg.libxcb
    udev nodejs ecasound
    alsa-lib
    # Additional safe libraries
    glibc curl icu libunwind libuuid lttng-ust krb5
    dbus expat libxkbcommon at-spi2-atk cairo pango
    systemd
    fontconfig
    libdbusmenu wayland libsecret
    xorg.libXScrnSaver xorg.libxshmfence xorg.libxkbfile
    libglvnd
  ];
in
pkgs.mkShell {
  buildInputs = neededLibs;
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath neededLibs}:$LD_LIBRARY_PATH
    echo "Library path set. Run ./antigravity"
  '';
}
