{ pkgs ? import <nixpkgs> {}}:

with pkgs; mkShell {

  nativeBuildInputs = let
    odin_neo = pkgs.odin.overrideAttrs (finalAttrs: previousAttrs: {
      version = "v0.12.0";
      src = fetchFromGitHub {
        owner = "odin-lang";
        repo = "Odin";
        rev = "${finalAttrs.version}";
        sha256 = "w3YDhOLmHdM4x6PgOaCT4l1qb8EM2CV0lEvFSqvBgiA=";
      };
    });
  in
    [
      odin_neo
    ];

}
