{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    shells.url = "github:anilanar/shells.nix";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils-plus, shells, ... }:
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;
      outputsBuilder = channels:
        let
          pkgs = channels.nixpkgs;
          unstable = channels.unstable;
        in {
          devShell = shells.lib.mkShell { inherit inputs; } {
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
