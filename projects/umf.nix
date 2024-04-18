{ pkgs, system, ... }: {
  config = {
    packages = with pkgs; [ teleport python310 pipenv ];
    js.enable = true;
    cypress.enable = system == "x86_64-linux";
    playwright.enable = system == "x86_64-linux";
    turborepo.enable = false;
    vscode = {
      enable = false;
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
