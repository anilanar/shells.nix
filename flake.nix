{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    fenix = { url = "github:nix-community/fenix"; };
    flake-utils.url = "github:numtide/flake-utils";
    vscode-extensions.url =
      "github:nix-community/nix-vscode-extensions/e4b75f0f77a31f42deef94bfbc10c4a48a11717f";
  };
  description = "A library for creating personal devenvs";
  outputs = inputs@{ nixpkgs, flake-utils, vscode-extensions, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        fenix = {
          inherit (inputs.fenix.packages.${system}.complete)
            cargo rustc rustfmt rust-src;
          inherit (pkgs.callPackage inputs.fenix { })
            rust-analyzer rust-analyzer-vscode-extension;
        };
        extensions = vscode-extensions.extensions.${system}.vscode-marketplace;
        mkShell = args:
          (import ./lib/mkShell.nix) {
            inherit pkgs inputs system extensions fenix;
            inherit (pkgs) lib;
            inherit (pkgs.lib) types;
          } (args // { modules = [ ./module.nix ] ++ args.modules; });
        mkVscode = import ./features/vscode/mk-vscode.nix {
          inherit pkgs extensions;
          inherit (pkgs) lib;
        };
        vscode = mkVscode { };
      in {
        lib = { inherit mkShell; };
        devShells.default = mkShell { modules = [{ vscode.enable = true; }]; };
        devShells.umf = mkShell { modules = [ ./projects/umf.nix ]; };
        packages.vscode = vscode;
      }) // {
        templates.default = { path = ./example; };
      };
}

