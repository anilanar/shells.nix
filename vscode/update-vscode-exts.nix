{ config, pkgs, inputs, ... }:
let
  pkg = pkgs.stdenv.mkDerivation {
    name = "update-vscode-exts";

    buildCommand = ''
      install -Dm755 $script $out/bin/update-vscode-exts
    '';

    script = pkgs.substituteAll {
      src = ./update-vscode-exts.sh;
      isExecutable = true;
      bash = "${pkgs.bash}/bin/sh";
      jq = "${pkgs.jq}/bin/jq";
      curl = "${pkgs.curl}/bin/curl";
      unzip = "${pkgs.unzip}/bin/unzip";
    };
  };
in { config = { packages = [ pkg ]; }; }
