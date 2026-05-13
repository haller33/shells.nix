{ pkgs ? import <nixpkgs> {} }:
let
  fhs = pkgs.buildFHSUserEnv {
    name = "morpheus-build";
    targetPkgs = pkgs: with pkgs; [
      llvm
      clang
      gcc                # replaces clang/llvm
      binutils
      coreutils          # for rm
      flex               # provides libfl
      cmake
      readline
      rcs
      glibc.dev          # crt1.o, crti.o
    ];
    runScript = "bash";
    env = {
      # Let the gcc wrapper pick up these flags (though it usually knows glibc)
      NIX_LDFLAGS = "-L${pkgs.glibc.dev}/lib";
      LDFLAGS    = "-L${pkgs.glibc.dev}/lib";
    };
    profile = ''
      # Create /bin and symlink rm (required by your script)
      if [ ! -e /bin ]; then
        mkdir -p /bin
      fi
      if [ ! -e /bin/rm ]; then
        ln -s ${pkgs.coreutils}/bin/rm /bin/rm
      fi

      # Export flags again to be sure
      export NIX_LDFLAGS="-L${pkgs.glibc.dev}/lib"
      export LDFLAGS="-L${pkgs.glibc.dev}/lib"

      echo "crt1.o is at: ${pkgs.glibc.dev}/lib/crt1.o"

      cd src
      PREFIX=PREFIX CFLAGS='-std=gnu89 -fcommon' make PREFIX=PREFIX
      exec zsh
    '';
  };
in
  fhs.env
