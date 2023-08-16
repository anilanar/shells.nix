{ config, lib, pkgs, ... }: {
  options = { playwright = { enable = lib.mkEnableOption "playwright browsers path in env"; }; };

  config = lib.mkIf (config.playwright.enable) {
    env = { 
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    };
  };
}

