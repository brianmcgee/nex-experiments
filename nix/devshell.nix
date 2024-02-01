{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
    inputs.process-compose-flake.flakeModule
  ];

  config.perSystem = {
    config,
    inputs',
    pkgs,
    ...
  }: {
    config.devshells.default = {
      env = [
        {
          name = "LD_LIBRARY_PATH";
          value = "$DEVSHELL_DIR/lib";
        }
      ];

      commands = [
        {package = pkgs.gomod2nix;}
        {package = inputs'.flake-linter.packages.default;}
      ];
    };
  };
}
