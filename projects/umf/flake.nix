{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    shells.url = "github:anilanar/shells.nix";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, shells, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ shells.flakeModule ];
      perSystem = { pkgs, ... }: {
        config = {
          js.enable = true;
          cypress.enable = true;
        };
      };
    };
}
