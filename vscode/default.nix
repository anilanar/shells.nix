{ config, lib, pkgs, types, extensions, ... }: {
  imports = [ ./update-vscode-exts.nix ./config.nix ];

  options = {
    vscode = {
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
        type = types.functionTo (types.listOf types.package);
        description =
          "List of extensions from the marketplace. See https://github.com/nix-community/nix-vscode-extensions";
        default = _: [ ];
      };

      exts' = lib.mkOption {
        type = types.listOf types.package;
        description = "List of extensions.";
        default = [ ];
      };
    };
  };

  config = {
    packages =
      let mkVscode = import ./mk-vscode.nix { inherit pkgs extensions; };
      in [ (mkVscode config.vscode) ];
  };
}
