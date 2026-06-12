{
  description = "hallwack's personal collection of software packages.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          helium-browser = pkgs.callPackage ./pkgs/helium-browser/default.nix { };
          zennotes = pkgs.callPackage ./pkgs/zennotes/default.nix { };
        }
      );
    };
}
