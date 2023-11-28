{
  description = "Website for benaryorg";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      nixosModules = rec
      {
        benaryorg-website = import ./nixos;
        default = benaryorg-website;
      };
      overlays = rec
      {
        benaryorg-website = final: prev:
        {
          benaryorg-website = prev.callPackage ./benaryorg-website.nix {};
        };
        default = benaryorg-website;
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        benaryorg-website = pkgs.callPackage ./benaryorg-website.nix {};
      in
        {
          packages =
          {
            default = benaryorg-website;
            benaryorg-website = benaryorg-website;
          };
        }
      );
}
