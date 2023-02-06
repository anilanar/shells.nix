let
  mkTurborepo = { buildGoModule, fetchFromGitHub, protobuf, protoc-gen-go
    , protoc-gen-go-grpc, ... }:
    buildGoModule rec {
      pname = "turborepo";
      version = "1.6.3";

      src = "${
          fetchFromGitHub {
            owner = "vercel";
            repo = "turbo";
            rev = "v${version}";
            sha256 = "csapIeVB0FrLnmtUmLrRe8y54xmK50X30CV476DXEZI=";
          }
        }/cli";

      vendorSha256 = "Kx/CLFv23h2TmGe8Jwu+S3QcONfqeHk2fCW1na75c0s=";
      nativeBuildInputs = [ protobuf protoc-gen-go protoc-gen-go-grpc ];

      preBuild = ''
        make compile-protos
      '';

      doCheck = false;
    };
in { config, lib, flake-parts-lib, ... }: {
  options.perSystem = flake-parts-lib.mkPerSystemOption ({ lib, ... }: {
    options.turborepo = { enable = lib.mkEnableOption "turborepo binary"; };
  });

  config.perSystem = { config, lib, system, pkgs, ... }:
    let turborepo = mkTurborepo pkgs;
    in lib.mkIf (config.turborepo.enable) {
      shells.packages = [ turborepo ];
      shells.env = { TURBO_BINARY_PATH = "${turborepo}/bin/turbo"; };
    };
}

