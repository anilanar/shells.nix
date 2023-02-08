{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  description = "A library for creating personal devenvs";
  outputs = inputs@{ flake-utils, vscode-extensions, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.fenix.overlays.default ];
        };
        fenix = inputs.fenix.packages.${system};
        extensions = vscode-extensions.extensions.${system}.vscode-marketplace;
        mkShell = args:
          (import ./lib/mkShell.nix) {
            inherit pkgs system extensions fenix;
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
        devShells.default = mkShell {
          modules = [{
            vscode.enable = true;
            rust.enable = true;
          }];
        };
        devShells.umf = mkShell { modules = [ ./projects/umf.nix ]; };
        packages.vscode = vscode;
      }) // {
        templates.default = { path = ./example; };
      };
}

