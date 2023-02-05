{
  description = "A `flake-parts` module for my personal shells";
  outputs = { self, ... }: {
    flakeModule = ./flake-module.nix;
    templates.default = {
      path = ./example;
    };
  };
}