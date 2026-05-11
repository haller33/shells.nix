# nix-shell -E 'with import <nixpkgs> {}; runCommand "dummy" { buildInputs = [ (callPackage ./default.nix { stdenv = gcc10Stdenv; boost = boost172; luajit = luajit.override { enable52Compat = true; }; }) ]; } ""'

{ stdenv, fetchFromGitHub, fetchgit, meson, ninja, boost, luajit, openssl
, ncurses, pkgconfig, xxd, re2c, gawk }:

let
  boost-static = boost.override { enableStatic = true; };
  re2c-2x = re2c.overrideAttrs (oldAttrs: rec {
    version = "2.0.3";
    src = fetchFromGitHub {
      owner = "skvadrik";
      repo = "re2c";
      rev = version;
      sha256 = "sha256-5iK8YpTXmJVCQ58U5iKY16C4J3IEMcHL6mCyJQg5do0=";
    };
    patches = null;
  });
in stdenv.mkDerivation rec {
  pname = "emilua";
  version = "0.4.3";

  src = fetchgit {
    url = "https://gitlab.com/emilua/emilua.git";
    rev = "v${version}";
    sha256 = "sha256-vZITPQ1qUHhw24c0HKdR6VenviOc6JizQQ8w7K94irc=";
  };

  buildInputs = [ meson ninja boost-static luajit openssl ncurses ];
  nativeBuildInputs = [ pkgconfig luajit xxd re2c-2x ];
  checkInputs = [ gawk ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131 # mark as stable doe inactivity
  # BOOST_INCLUDEDIR = "${stdenv.glibc.getDev boost-static}/include";
  # BOOST_LIBRARYDIR = "${stdenv.glibc.getLib boost-static}/lib";

  mesonFlags = [ "-Denable_http=true" "-Denable_tests=true" ];

  doCheck = true;
}
