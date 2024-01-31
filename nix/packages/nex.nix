{
  lib,
  cni,
  cni-plugins,
  nex-source,
  firecracker,
  tc-redirect-tap,
  buildGoModule,
}:
buildGoModule rec {
  pname = "nex";
  version = "0.1.3";

  src = nex-source;

  vendorHash = "sha256-xAH/usI/qF78r4RoNfuXfCpkR4swg7V5ntr4MK2JTtk=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.VERSION=0.1.3'"
    "-X 'main.COMMIT=${src.shortRev}'"
    "-X 'main.BUILDDATE=Nix'"
  ];

  # runtime dependencies
  buildInputs = [
    cni
    cni-plugins
    firecracker
    tc-redirect-tap
  ];

  subPackages = [
    "nex"
    "agent/fc-image"
    "agent/cmd/nex-agent"
  ];

  meta = with lib; {
    description = "The NATS execution engine";
    homepage = "https://github.com/synadia-io/nex";
    license = licenses.asl20;
    mainProgram = "nex";
    platforms = ["x86_64-linux"];
  };
}
