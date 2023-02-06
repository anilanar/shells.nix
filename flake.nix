{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  description = "A `flake-parts` module for my personal shells";
  outputs = inputs@{ self, nixpkgs, flake-parts, vscode-extensions, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    (let flakeModule = ./flake-module.nix;
    in {
      imports = [ flakeModule ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake = {
        inherit flakeModule;
        templates.default = { path = ./example; };
      };

      perSystem = { config, pkgs, ... }: {
        config.shells.env = {
          FOO = "BAR";
          BAR = "1";
        };
        config.js.enable = true;
        config.cypress.enable = false;
        config.turborepo.enable = true;
      };
    });
}
