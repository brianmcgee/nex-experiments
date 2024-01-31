_: {
  config.perSystem = {
    pkgs,
    config,
    ...
  }: {
    config.devshells.default = {
      commands = [
        {package = pkgs.nex;}
        {package = pkgs.firecracker;}
        {package = pkgs.cni;}
        {package = pkgs.cni-plugins;}
        {package = pkgs.tc-redirect-tap;}
      ];
    };
  };
}
