{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  description = "A library for creating personal devenvs";
  outputs = inputs@{ nixpkgs, flake-utils, vscode-extensions, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mkShell = import ./mkShell.nix {
          inherit pkgs inputs system;
          extensions =
            vscode-extensions.extensions.${system}.vscode-marketplace;
        };
      in {
        devShells.default = mkShell { modules = [ ]; };
        devShells.umf = mkShell { modules = [ ./projects/umf.nix ]; };
      });
}

