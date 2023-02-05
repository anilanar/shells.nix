{ config, ... }: {
  config.perSystem = { config, pkgs, ... }:
    let
      settings-file = pkgs.writeText "vscode-user-settings"
        (builtins.toJSON config.vscode.settings);
      keybindings-file = pkgs.writeText "vscode-user-keybindings"
        (builtins.toJSON config.vscode.keybindings);
      vscode = pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions =
          (builtins.map pkgs.vscode-utils.extensionFromVscodeMarketplace
            config.vscode.exts);
      };
      bin = pkgs.writeScriptBin "code" ''
        hash=$(nix hash path --base32 ${vscode})
        tmpdir=$(dirname $(mktemp -u))/$(whoami)/$hash
        mkdir -p $tmpdir/User
        ln -sfn ${settings-file} $tmpdir/User/settings.json
        ln -sfn ${keybindings-file} $tmpdir/User/keybindings.json

        exec "${vscode}/bin/codium" --user-data-dir $tmpdir "$@"
      '';
    in { config.shells.packages = [ bin ]; };
}
