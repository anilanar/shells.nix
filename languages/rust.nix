{ config, lib, types, pkgs, ... }: {
  options = { rust = { enable = lib.mkEnableOption "rust shell"; }; };

  config = lib.mkIf config.rust.enable {
    packages = with pkgs; [ rustc cargo rustfmt openssl rustup ];

    env = {
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    vscode.exts = exts: with exts; [ rust-lang.rust-analyzer ];
  };
}
