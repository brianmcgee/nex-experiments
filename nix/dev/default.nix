{...}: {
  imports = [
    ./binary-cache
    ./nats.nix
    ./nex.nix
  ];

  perSystem = {
    config.process-compose.dev.settings = {
      log_location = "$PRJ_DATA_DIR/dev.log";
    };

    config.devshells.default = {
      commands = [
        {
          help = "run local dev services";
          name = "dev";
          command = ''nix run .#dev "$@"'';
        }
        {
          help = "re-initialise data directory";
          name = "dev-init";
          command = "rm -rf $PRJ_DATA_DIR && direnv reload";
        }
      ];
    };
  };
}
