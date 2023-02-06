{ config, flake-parts-lib, ... }: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, ... }:
    (let types = lib.types;
    in { options.rust = { enable = lib.mkEnableOption "rust shell"; }; }));

  config.perSystem = { config, lib, pkgs, ... }: {
    shells.packages = lib.mkIf config.js.enable
      (with pkgs; [ rustc cargo rustfmt openssl rustup ]);

    shells.env = {
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    vscode.exts = exts: with exts; [ rust-lang.rust-analyzer ];
  };
}
