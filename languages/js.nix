{ config, flake-parts-lib, ... }: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, ... }:
    (let types = lib.types;
    in { options.js = { enable = lib.mkEnableOption "js shell"; }; }));

  config.perSystem = { config, lib, pkgs, system, inputs', ... }: {
    shells.packages = lib.mkIf config.js.enable (with pkgs; [
      nodejs-18_x
      nodePackages.pnpm
      nodePackages.yarn
      automake
      autoconf
      watchman
    ]);

    vscode.exts = with inputs'.vscode-extensions.extensions;
      [ dbaeumer.vscode-eslint ];
  };
}

