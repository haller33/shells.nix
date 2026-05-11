{ pkgs ? import <nixpkgs> {}}:

with pkgs; mkShell {

  nativeBuildInputs = let
    odin_neo = pkgs.odin.overrideAttrs (finalAttrs: previousAttrs: {
      version = "v0.13.0";
      src = fetchFromGitHub {
        owner = "odin-lang";
        repo = "Odin";
        rev = "${finalAttrs.version}";
        sha256 = "ke2HPxVtF/Lh74Tv6XbpM9iLBuXLdH1+IE78MAacfYY=";
      };
    });
  in
    [
      odin_neo
    ];

}
