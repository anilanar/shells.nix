{ config, lib, pkgs, ... }: {
  options = {
    turborepo = { enable = lib.mkEnableOption "turborepo binary"; };
  };

  config = let turborepo = pkgs.turbo;
  in lib.mkIf (config.turborepo.enable) {
    packages = [ turborepo ];
    env = { TURBO_BINARY_PATH = "${turborepo}/bin/turbo"; };
  };
}

