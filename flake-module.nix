{ lib, pkgs, flake-parts-lib, ... }:
let types = lib.types;
in {
  imports = [ ./vscode ];

  options.perSystem = flake-parts-lib.mkPerSystemOption
    ({ config, pkgs, ... }: {
      options.shells = lib.mkOption {
        type = types.submodule {
          options = {
            packages = lib.mkOption {
              type = types.listOf types.package;
              description =
                "A list of packages to expose inside the developer environment. Search available packages using ``devenv search NAME``.";
              default = [ ];
            };
          };
        };
        default = { };
      };
    });

  config.perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell { buildInputs = config.shells.packages; };
  };
}
