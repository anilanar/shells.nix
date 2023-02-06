{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    shells.url = "github:anilanar/shells.nix";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, shells, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ shells.flakeModule ];
      perSystem = { pkgs, ... }: {
        config = {
          shells.packages = [ ];
          shells.env = { FOO = "BAR"; };
          js.enable = false;
          rust.enable = false;
          cypress.enable = false;
          turborepo.enable = false;
        };
      };
    };
}
