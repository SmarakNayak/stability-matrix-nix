{
  description = "StabilityMatrix - Multi-platform package manager for Stable Diffusion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.callPackage ./package.nix {};
        packages.stability-matrix = pkgs.callPackage ./package.nix {};

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/stability-matrix";
        };
      }
    ) // {
      overlays.default = final: prev: {
        stability-matrix = final.callPackage ./package.nix {};
      };
    };
}
