{
  lib,
  cni,
  buildGoModule,
  tc-redirect-tap-source,
}:
buildGoModule rec {
  pname = "tc-redirect-tap";
  version = "0.0.1+dev";

  src = tc-redirect-tap-source;

  # the source specifies go 1.11 and without patching the version to 1.17 we were getting the followin error:
  #     unsafe.Slice requires go1.17 or later (-lang was set to go1.16; check go.mod)
  #  patches = [
  #    ./go-version.patch
  #  ];

  vendorHash = "sha256-kR1RjcSRnrVh92ubdjiMhoE1kMD/72vcdEv1Qez+HqM=";

  ldflags = ["-s" "-w"];

  CGO_ENABLED = 0;

  subPackages = ["cmd/tc-redirect-tap"];

  # runtime dependencies
  buildInputs = [cni];

  meta = with lib; {
    description = "This plugin allows you to adapt pre-existing CNI plugins/configuration to a tap device";
    homepage = "https://github.com/awslabs/tc-redirect-tap";
    license = licenses.asl20;
    mainProgram = "tc-redirect-tap";
    platforms = ["x86_64-linux"];
  };
}
