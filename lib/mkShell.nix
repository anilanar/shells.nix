args@{ pkgs, ... }:
{ modules, ... }:
let
  eval = pkgs.lib.evalModules {
    modules = [{ _module = { inherit args; }; }] ++ modules;
  };
in eval.config.shell
