{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
    inputs.process-compose-flake.flakeModule
  ];

  config.perSystem = {
    config,
    inputs',
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
        {package = inputs'.flake-linter.packages.default;}
      ];
    };
  };
}
