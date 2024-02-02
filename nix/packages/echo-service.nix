{
  lib,
  musl,
  buildGoApplication,
}:
buildGoApplication rec {
  pname = "echo-service";
  version = "0.0.1+dev";

  src = ../..;
  modules = ../../gomod2nix.toml;

  nativeBuildInputs = [musl];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-linkmode external"
    "-extldflags '-static -L${musl}/lib'"
  ];

  subPackages = ["examples/services/echo"];

  meta = with lib; {
    mainProgram = "echo";
    platforms = ["x86_64-linux"];
  };
}
