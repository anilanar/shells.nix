{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  description = "A `flake-parts` module for my personal shells";
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
    (let flakeModule = ./flake-module.nix;
    in {
      systems = nixpkgs.lib.systems.flakeExposed;
      flake = {
        inherit flakeModule;
        templates.default = { path = ./example; };
        vscode.exts = [ ];
      };
      imports = [ flakeModule ];
      perSystem = { config, pkgs, ... }: {
        config.shells.packages = [ ];
        # config.vscode.exts = [ ];
      };
    });
}
