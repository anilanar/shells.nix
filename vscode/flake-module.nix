{ lib, flake-parts-lib, inputs, ... }:
let
  types = lib.types;

  vscodeExtensionType = types.submodule {
    options = {
      name = lib.mkOption {
        type = types.str;
        description = "Extension name. For foo.bar, name is bar.";
        example = "vim";
      };
      publisher = lib.mkOption {
        type = types.str;
        description = "Extension publisher. For foo.bar, publisher is foo.";
        example = "vscodevim";
      };
      version = lib.mkOption {
        type = types.str;
        description = "Version as declared in vscode marketplace.";
        example = "1.0.0";
      };
      sha256 = lib.mkOption {
        type = types.str;
        example = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
      };
    };
  };
in {
  imports = [ ./update-vscode-exts.nix ./config.nix ];

  options.perSystem = flake-parts-lib.mkPerSystemOption ({ ... }: {
    options.vscode = lib.mkOption {
      type = types.submodule {
        options = {
          settings = lib.mkOption {
            type = types.attrs;
            example = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";

              "editor.quickSuggestions" = {
                comments = "off";
                strings = "off";
              };

              "[nix]" = {
                "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
              };
            };
          };

          keybindings = lib.mkOption {
            type = types.listOf (types.submodule {
              options = {
                key = lib.mkOption {
                  type = types.str;
                  example = "ctrl+shift+d";
                };
                command = lib.mkOption {
                  type = types.str;
                  example = "references-view.find";
                };
                when = lib.mkOption {
                  type = types.nullOr types.str;
                  example = "editorHasReferenceProvider";
                  default = null;
                };
              };
            });
            example = [
              {
                key = "ctrl+shift+d";
                command = "-workbench.view.debug";
              }
              {
                key = "ctrl+shift+d";
                command = "references-view.find";
                when = "editorHasReferenceProvider";
              }
              {
                key = "ctrl+shift+x";
                command = "-workbench.view.extensions";
              }
            ];
          };

          exts = lib.mkOption {
            type = types.listOf vscodeExtensionType;
            description =
              "List of extensions. Can use `update-vscode-exts` script to get a list";
            example = [
              {
                name = "Nix";
                publisher = "bbenoist";
                version = "1.0.1";
                sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
              }
              {
                name = "vim";
                publisher = "vscodevim";
                version = "1.24.3";
                sha256 = "02alixryryak80lmn4mxxf43izci5fk3pf3pcwy52nbd3d2fiwz1";
              }
            ];
            default = [ ];
          };
        };
      };
    };
  });

  config.perSystem = { config, pkgs, system, inputs', ... }:
    let
      mkVscode = import ./mk-vscode.nix {
        inherit pkgs;
        inherit (inputs'.vscode-extensions) extensions;
      };
    in {
      config.shells.packages = [
        (mkVscode {
          settings = config.vscode.settings;
          keybindings = config.vscode.settings;
          exts = config.vscode.exts;
        })
      ];
    };
}
