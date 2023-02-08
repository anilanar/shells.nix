args@{ pkgs, ... }:
{ modules, ... }:
let
  eval =
    pkgs.lib.evalModules { modules = [{ _module.args = args; }] ++ modules; };
in eval.config.shell
