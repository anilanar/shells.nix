{ config, lib, types, pkgs, fenix, ... }: {
  options = { rust = { enable = lib.mkEnableOption "rust shell"; }; };

  config = lib.mkIf config.rust.enable {
    packages = [ fenix.default.toolchain pkgs.rust-analyzer-nightly ];

    env = {
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    vscode.exts' = [ pkgs.vscode-extensions.rust-lang.rust-analyzer-nightly ];
  };
}
