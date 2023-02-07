{ pkgs, extensions, inputs, system, ... }:
{ modules, ... }:
let
  eval = pkgs.lib.evalModules {
    modules = [
      {
        _module.args = {
          inherit pkgs inputs extensions system;
          inherit (pkgs) lib;
          inherit (pkgs.lib) types;
        };
      }
      ./module.nix
    ] ++ modules;
  };
in eval.config.shell
