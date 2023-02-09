{ config, lib, types, pkgs, fenix, ... }: {
  options = { rust = { enable = lib.mkEnableOption "rust shell"; }; };

  config = lib.mkIf config.rust.enable {
    packages = with fenix; [ cargo rustc rustfmt rust-analyzer ];

    env = {
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      RUST_SRC_PATH = "${fenix.rust-src}/lib/rustlib/src/rust/library";
    };

    vscode.exts' = [ fenix.rust-analyzer-vscode-extension ];

    vscode.settings = {
      "[rust]" = { editor.defaultFormatter = "matklad.rust-analyzer"; };
    };
  };
}
