{
  pkgs ? import <nixpkgs> { },
}:

{
  helium-browser = pkgs.callPackage ./pkgs/helium-browser/default.nix { };
  zennotes = pkgs.callPackage ./pkgs/zennotes/default.nix { };
}
