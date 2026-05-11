let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  pkgs = import <nixpkgs> { };
  unstable = import unstableTarball {};
in
with pkgs;
mkShell {

  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
    with pkgs;
    pkgs.lib.makeLibraryPath [ libGL xorg.libX11 xorg.libXi ]
  }";
  nativeBuildInputs = let
    odin_neo = pkgs.odin.overrideAttrs (finalAttrs: previousAttrs: {
      pname = "odin_neo";
      version = "dev-2023-10";

      src = fetchFromGitHub {
        owner = "odin-lang";
        repo = "Odin";
        rev = finalAttrs.version;
        hash = "sha256-ZKxTkqPjbr/xw1HJ8jWrN4R1i9tKrZT9AGWFHIhpC1E=";
        # name = "${finalAttrs.pname}-${finalAttrs.version}"; # not gona work .
      };

      nativeBuildInputs = [ makeBinaryWrapper which ];

      buildInputs = lib.optional stdenv.isDarwin libiconv;

      LLVM_CONFIG = "${llvmPackages.llvm.dev}/bin/llvm-config";

      postPatch = lib.optionalString stdenv.isDarwin ''
        sed -i src/main.cpp \
          -e 's|-syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk|-syslibroot ${MacOSX-SDK}|'
      '' + ''
        sed -i build_odin.sh \
          -e 's/^GIT_SHA=.*$/GIT_SHA=/' \
          -e 's/LLVM-C/LLVM/' \
          -e 's/framework System/lSystem/'
        patchShebangs build_odin.sh
      '';

      dontConfigure = true;

      buildFlags = [ "release" ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp odin $out/bin/odin

        mkdir -p $out/share
        cp -r core $out/share/core
        cp -r vendor $out/share/vendor

        wrapProgram $out/bin/odin \
          --prefix PATH : ${
            lib.makeBinPath (with llvmPackages; [ bintools llvm clang lld ])
          } \
          --set-default ODIN_ROOT $out/share

        runHook postInstall
      '';

    });
  in [ odin_neo ] ++ [
    unstable.ols
    
    glxinfo
    lld
    gnumake
    xorg.libX11.dev
    xorg.libX11
    xorg.libXft
    xorg.libXi
    xorg.libXinerama
    libGL

    # needed for raylib
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
  ];
}
