{ pkgs ? import <nixpkgs> { config.allowBroken = true; } }:

let
  # Using lua5_2 as confirmed by your previous error
  myLua = pkgs.lua5_2.withPackages (ps: [
    ps.luasql-sqlite3
    ps.luasocket
    ps.dkjson
    ps.luarocks # Adding it to the Lua environment
  ]);
in
pkgs.mkShell {
  name = "lfm-lua-env";

  buildInputs = [
    myLua
    pkgs.sqlite
    pkgs.luarocks # Also adding the standalone binary
  ];

  shellHook = ''
    export LUA_CPATH="${myLua}/lib/lua/5.2/?.so;;"
    export LUA_PATH="${myLua}/share/lua/5.2/?.lua;;"

    echo "--- LFM Environment with Luarocks ---"
    echo "Luarocks version: $(luarocks --version | head -n 1)"
    echo "Lua version: $(lua -v)"
  '';
}
