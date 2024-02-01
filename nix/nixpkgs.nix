{
  self,
  inputs,
  ...
}: {
  perSystem = {system, ...}: {
    # customize nixpkgs instance
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        # add packages exposed by this flake
        self.overlays.default
        # adds buildGoApplication
        inputs.gomod2nix.overlays.default
      ];
    };
  };
}
