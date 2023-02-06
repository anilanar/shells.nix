{ config, flake-parts-lib, ... }: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, ... }:
    (let types = lib.types;
    in {
      options.shells.js = lib.mkOption {
        type = types.submodule {
          options = {
            enable = lib.mkEnableOption "js shell";
            cypress = lib.mkEnableOption "cypress";
          };
        };
        default = { };
      };
    }));

  config.perSystem = { config, lib, pkgs, system, inputs', ... }:
    let cypress-latest = import ./cypress.nix pkgs;
    in {
      shells.packages = lib.mkIf config.shells.js.enable (with pkgs;
        [
          nodejs-18_x
          nodePackages.pnpm
          nodePackages.yarn
          automake
          autoconf
          watchman
        ] ++ (if config.shells.js.cypress && system == "x86_64-linux" then
          [ cypress-latest ]
        else
          [ ]));

      vscode.exts = with inputs'.vscode-extensions.extensions;
        [ dbaeumer.vscode-eslint ];
    };
}

