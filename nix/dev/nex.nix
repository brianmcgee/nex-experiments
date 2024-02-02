_: {
  config.perSystem = {
    pkgs,
    config,
    ...
  }: {
    config.devshells.default = {
      commands = [
        # we wrap nex like this to ensure it looks up contexts in the .data directory
        # when invoking with sudo be sure to run it like this: `sudo -E nex --context ExpNode ...`
        {
          name = "nex";
          category = "synadia";
          help = "NATS Execution Engine CLI Version";
          command = ''XDG_CONFIG_HOME=$PRJ_DATA_DIR ${pkgs.nex}/bin/nex "$@"'';
        }
      ];
    };
  };
}
