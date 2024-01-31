{inputs, ...}: {
  imports = [
    inputs.flake-root.flakeModule
    ./checks.nix
    ./treefmt.nix
    ./nixpkgs.nix
    ./packages
    ./devshell.nix
    ./dev
  ];
}
