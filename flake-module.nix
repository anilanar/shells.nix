{ lib, flake-parts-lib, ... }:
let types = lib.types;
in {
  imports = [
    ./languages/js.nix
    ./vscode
    ./cypress.nix
    ./turborepo.nix
  ];

  options.perSystem = flake-parts-lib.mkPerSystemOption ({ ... }: {
    options.shells = {
      packages = lib.mkOption {
        type = types.listOf types.package;
        description =
          "A list of packages to expose inside the developer environment. Search available packages using ``devenv search NAME``.";
        default = [ ];
      };
      env = lib.mkOption {
        type = types.attrsOf types.str;
        description = "Key value pairs for env. variables";
        example = { FOO = "1"; };
        default = { };
      };
    };
  });

  config.perSystem = { config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      buildInputs = config.shells.packages;
      shellHook = builtins.concatStringsSep "\n"
        (lib.attrsets.mapAttrsToList (name: value: "${name}=${value}")
          config.shells.env);
    };
  };

  # maps inputs.vscode-extensions.extensions.${system}.vscode-marketplace to 
  # inputs'.vscode-extensions.extensions, with system applied and with
  # vscode-marketplace inbetween attr removed.
  config.perInput = system: flake:
    lib.optionalAttrs (flake ? extensions.${system}.vscode-marketplace) {
      extensions = flake.extensions.${system}.vscode-marketplace;
    };
}
