{ config, types, lib, pkgs, ... }: {
  options = { js = { enable = lib.mkEnableOption "js shell"; }; };

  config = {
    packages = lib.mkIf config.js.enable (with pkgs; [
      nodejs-18_x
      nodePackages.pnpm
      nodePackages.yarn
      automake
      autoconf
      watchman
    ]);

    vscode.exts = exts: with exts; [ dbaeumer.vscode-eslint ];
  };
}
