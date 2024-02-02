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
      commands = let
        category = "development";
      in [
        {
          name = "dev";
          inherit category;
          help = "run local dev services";
          command = ''nix run .#dev "$@"'';
        }
        {
          name = "dev-init";
          inherit category;
          help = "re-initialise data directory";
          command = "rm -rf $PRJ_DATA_DIR && direnv reload";
        }
      ];
    };
  };
}
