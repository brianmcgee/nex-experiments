{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages = let
      inherit (pkgs) callPackage;
    in rec {
      tc-redirect-tap = callPackage ./tc-redirect-tap {inherit (inputs) tc-redirect-tap-source;};
      nex = callPackage ./nex.nix {inherit (inputs) nex-source;};
      echo-service = callPackage ./echo-service.nix {};
    };
  };

  flake.overlays.default = final: _prev: {
    inherit (self.packages.${final.system}) nex tc-redirect-tap;
  };
}
