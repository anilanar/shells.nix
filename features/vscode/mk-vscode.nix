{ pkgs, lib, extensions, ... }:
{ settings ? { }, keybindings ? [ ], exts ? _: [ ], exts' ? [ ], ... }:
let
  config = import ./config.nix { inherit pkgs; };
  all-settings = lib.recursiveUpdate config.settings settings;
  all-keybindings = config.keybindings ++ keybindings;
  settings-file =
    pkgs.writeText "vscode-user-settings" (builtins.toJSON all-settings);
  keybindings-file =
    pkgs.writeText "vscode-user-keybindings" (builtins.toJSON all-keybindings);
  vscode = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = with extensions;
      [
        vscodevim.vim
        bbenoist.nix
        eamodio.gitlens
        brettm12345.nixfmt-vscode
        editorconfig.editorconfig
        esbenp.prettier-vscode
        github.copilot
      ] ++ (exts extensions) ++ exts';
  };
  bin = pkgs.writeScriptBin "code" ''
    hash=$(nix hash path --base32 ${vscode})
    tmpdir=$(dirname $(mktemp -u))/$(whoami)/$hash
    mkdir -p $tmpdir/User
    ln -sfn ${settings-file} $tmpdir/User/settings.json
    ln -sfn ${keybindings-file} $tmpdir/User/keybindings.json

    exec "${vscode}/bin/codium" --user-data-dir $tmpdir "$@"
  '';
in bin
