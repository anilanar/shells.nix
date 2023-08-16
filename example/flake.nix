{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    shells.url = "github:anilanar/shells.nix";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, shells, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = shells.lib.${system}.mkShell {
        modules = [{
          packages = [ ];
          env = { FOO = "BAR"; };
          vscode.enable = false;
          js.enable = false;
          rust.enable = false;
          cypress.enable = false;
          playwright.enable = false;
          turborepo.enable = false;
        }];
      };
    });
}
