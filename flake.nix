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
        extensions = vscode-extensions.extensions.${system}.vscode-marketplace;
        mkShell = args:
          (import ./lib/mkShell.nix) { inherit pkgs inputs system extensions; }
          (args // { modules = [ ./module.nix ] ++ args.modules; });
      in {
        lib = { inherit mkShell; };
        devShells.default = mkShell { modules = [{ vscode.enable = true; }]; };
        devShells.umf = mkShell { modules = [ ./projects/umf.nix ]; };
      });
}

