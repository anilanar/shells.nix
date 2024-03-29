{ config, types, lib, pkgs, ... }: {
  options = {
    js = {
      enable = lib.mkEnableOption "js shell";
      nodejs = lib.mkOption {
        type = types.package;
        default = pkgs.nodejs_20;
        defaultText = lib.literalExpression "pkgs.nodejs_20";
        description = lib.mdDoc "Nodejs package to use.";
      };
    };
  };

  config = {
    packages = lib.mkIf config.js.enable (with pkgs; [
      config.js.nodejs
      nodePackages.pnpm
      nodePackages.yarn
      automake
      autoconf
      watchman
    ]);

    vscode.exts = exts: with exts; [ dbaeumer.vscode-eslint ];
  };
}
