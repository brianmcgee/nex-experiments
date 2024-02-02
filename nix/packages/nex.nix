{
  lib,
  cni-plugins,
  nex-source,
  firecracker,
  makeWrapper,
  tc-redirect-tap,
  buildGoModule,
}:
buildGoModule rec {
  pname = "nex";
  version = "0.1.3";

  src = nex-source;

  vendorHash = "sha256-/rZjZ8XH33ZEdID0ZJNQyk1I+IujU6Rx6Vr5ZIArtNY=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.VERSION=0.1.3'"
    "-X 'main.COMMIT=${lib.attrByPath ["shortRev"] "unknown" src}'"
    "-X 'main.BUILDDATE=Nix'"
  ];

  subPackages = [
    "nex"
    "agent/fc-image"
    "agent/cmd/nex-agent"
  ];

  nativeBuildInputs = [makeWrapper];

  postInstall = let
    runtimePkgs = [
      cni-plugins
      firecracker
      tc-redirect-tap
    ];
  in ''
    wrapProgram $out/bin/nex \
        --prefix PATH : ${lib.makeBinPath runtimePkgs}
  '';

  meta = with lib; {
    description = "The NATS execution engine";
    homepage = "https://github.com/synadia-io/nex";
    license = licenses.asl20;
    mainProgram = "nex";
    platforms = ["x86_64-linux"];
  };
}
