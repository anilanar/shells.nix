{ config, pkgs, ... }: {
  config.perSystem = { config, ... }: {
    config.vscode = {
      settings = {
        emmet.excludeLanguages = [ "javascriptreact" "typescriptreact" ];
        editor.suggestOnTriggerCharacters = false;
        editor.quickSuggestions = {
          "comments" = "off";
          "strings" = "off";
          "other" = "off";
        };
        update.mode = "none";
        # "terminal.external.linuxExec" = pkgs.zsh;
        terminal.integrated.copyOnSelection = true;
        terminal.integrated.cursorBlinking = true;
        vim.useSystemClipboard = true;
        vim.handleKeys = {
          "<C-k>" = false;
          "<C-b>" = false;
          "<C-f>" = false;
        };
        window.zoomLevel = -1;
        workbench.tree.indent = 20;
        editor.autoClosingBrackets = "never";
        workbench.editor.enablePreview = false;
        editor.inlineSuggest.enabled = true;
        editor.rulers = [ 80 ];

        editor.defaultFormatter = "esbenp.prettier-vscode";
        "[nix]" = { editor.defaultFormatter = "brettm12345.nixfmt-vscode"; };
        "[rust]" = { editor.defaultFormatter = "matklad.rust-analyzer"; };
        "[feature]" = {
          editor.defaultFormatter = "alexkrechik.cucumberautocomplete";
        };
      };

      keybindings = [
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
          key = "shift+alt+f12";
          command = "-references-view.find";
          when = "editorHasReferenceProvider";
        }
        {
          key = "ctrl+shift+x";
          command = "-workbench.view.extensions";
        }
        {
          key = "ctrl+shift+x";
          command = "terminal.focus";
        }
        {
          key = "ctrl+space";
          command = "editor.action.triggerSuggest";
          when = "editorHasCompletionItemProvider && !editorReadonly";
        }
        {
          key = "ctrl+space";
          command = "-editor.action.triggerSuggest";
          when =
            "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
        }
      ];
    };
  };
}
