{ config, lib, pkgs, ... }: {
  options = { cypress = { enable = lib.mkEnableOption "cypress binary"; }; };

  config = let cypress = pkgs.cypress;
  in lib.mkIf (config.cypress.enable) {
    packages = [ cypress ];
    env = { CYPRESS_RUN_BINARY = "${cypress}/bin/Cypress"; };
  };
}

