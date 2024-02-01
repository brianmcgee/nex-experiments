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

        {
          package = pkgs.writeShellApplication {
            name = "clean";
            text = ''
              for name in $(ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | grep veth)
              do
                  echo "$name"
                  sudo ip link delete "$name"
              done
            '';
          };
        }
      ];
    };
  };
}
