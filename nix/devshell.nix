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
      commands = [
        {package = pkgs.gomod2nix;}
        {package = pkgs.go-task;}
        {package = pkgs.ginkgo;}
        {package = pkgs.firecracker;}
        {package = inputs'.flake-linter.packages.default;}
        {
          category = "development";
          help = "remove stale network namespaces";
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
        {
          category = "docs";
          package = pkgs.vhs;
          help = "generate terminal gifs";
        }
        {
          category = "docs";
          help = "regenerate gifs for docs";
          name = "gifs";
          command = ''
            for tape in $PRJ_ROOT/docs/vhs/*; do
                vhs $tape -o "$PRJ_ROOT/docs/assets/$(basename $tape .tape).gif"
            done
          '';
        }
      ];
    };
  };
}
