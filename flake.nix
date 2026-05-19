{
  description = "mkdocs-status";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };
  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:
    let
      pkgsFor = system: import nixpkgs { inherit system; };
      forAllSystems = fn: nixpkgs.lib.genAttrs (import systems) (system: fn (pkgsFor system));
    in
    {
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            mkdocs
            python313Packages.mkdocs-awesome-nav
            python313Packages.mkdocs-git-revision-date-localized-plugin
            python313Packages.mkdocs-material
            python313Packages.mkdocs-rss-plugin
          ];
        };
      });
    };
}
