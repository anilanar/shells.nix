{ pkgs, ... }: {
  config = {
    js.enable = true;
    cypress.enable = true;
    vscode = {
      enable = true;
      exts = _:
        [
          (pkgs.vscode-utils.extensionFromVscodeMarketplace {
            name = "jestRunIt";
            publisher = "vespa-dev-works";
            version = "0.6.0";
            sha256 = "0i05153n9p4izlspz701qdhmz08wszn4ajliamx72x0r2na3bxcy";
          })
        ];
    };
  };
}
