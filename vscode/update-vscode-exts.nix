{ config, pkgs, inputs, ... }:
let
  update-vscode-exts = pkgs.stdenv.mkDerivation {
    name = "update-vscode-exts";

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/bin
      cp ${inputs.nixpkgs}/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh $out/bin/update-vscode-exts
    '';
  };
in { config.packages = [ update-vscode-exts ]; }
