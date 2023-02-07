{ config, lib, pkgs, types, ... }: {
  imports = [
    ./features/vscode
    ./features/cypress.nix
    ./features/turborepo.nix
    ./languages/js.nix
    ./languages/rust.nix
  ];

  options = {
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
    shell = lib.mkOption {
      type = types.package;
      internal = true;
    };
  };

  config = {
    shell = pkgs.mkShell {
      buildInputs = config.packages;
      shellHook = builtins.concatStringsSep "\n"
        (lib.attrsets.mapAttrsToList (name: value: "export ${name}=${value}")
          config.env);
    };
  };
}
