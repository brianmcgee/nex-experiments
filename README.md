# Nex Experiments

Status: _EXPERIMENTAL_

Playing around with [Nex](https://github.com/synadia-io/nex) using [Nix](https://nixos.org).

-   [x] create a Nix based dev environment for running Nex.
-   [ ] replace the underlying VM with one based on NixOS
-   [ ] add a Nix provider which supports shipping services as Nix store paths via binary caches instead of static binaries.

## Requirements

You must be familiar with and have the following installed:

-   [Direnv](https://direnv.net)
-   [Nix](https://nixos.org)

## Quick Start

After cloning the repository cd into the root directory and run:

```terminal
direnv allow
```

You will be asked to accept config for some additional substituters to which you should select yes.

Once the dev shell has finished initialising you can view the available commands using `menu`:

```terminal
❯ menu

[[general commands]]

  flake-linter
  fmt          - format the repo
  gomod2nix    - Convert applications using Go modules -> Nix
  menu         - prints this menu

[development]

  clean        - remove stale network namespaces
  dev          - run local dev services
  dev-init     - re-initialise data directory

[docs]

  vhs          - generate terminal gifs

[synadia]

  nats         - NATS Server and JetStream administration
  nex          - NATS Execution Engine CLI Version
  nsc          - creates NATS operators, accounts, users, and manage their permissions

```

To start the local dev services type `dev`.

![](./docs/assets/dev.gif)

> NOTE: the `nats-setup` service might report `Error: the account "Exp" already exists`. This is normal and happens
> after the first time the dev env is run.

With the dev services up and running you can now run the Nex preflight check:

```terminal
❯ nex node preflight
Validating - Required CNI Plugins
        🔎 Searching - /opt/cni/bin
        🔎 Searching - /nix/store/x5b1w4jkzy2vz06adx8jw04sj2z8flgp-cni-plugins-1.4.0/bin
          ✅ Dependency Satisfied - /nix/store/x5b1w4jkzy2vz06adx8jw04sj2z8flgp-cni-plugins-1.4.0/bin/host-local [host-local CNI plugin]
          ✅ Dependency Satisfied - /nix/store/x5b1w4jkzy2vz06adx8jw04sj2z8flgp-cni-plugins-1.4.0/bin/ptp [ptp CNI plugin]
        🔎 Searching - /nix/store/5hyh2imlw9xh76h92al4hi6wghdkbb1z-firecracker-1.5.0/bin
        🔎 Searching - /nix/store/vjnk15z04mr27c9wz09ky7028mi5bvhc-tc-redirect-tap-0.0.1+dev/bin
          ✅ Dependency Satisfied - /nix/store/vjnk15z04mr27c9wz09ky7028mi5bvhc-tc-redirect-tap-0.0.1+dev/bin/tc-redirect-tap [tc-redirect-tap CNI plugin]

Validating - Required binaries
        🔎 Searching - /usr/local/bin
        🔎 Searching - /nix/store/x5b1w4jkzy2vz06adx8jw04sj2z8flgp-cni-plugins-1.4.0/bin
        🔎 Searching - /nix/store/5hyh2imlw9xh76h92al4hi6wghdkbb1z-firecracker-1.5.0/bin
          ✅ Dependency Satisfied - /nix/store/5hyh2imlw9xh76h92al4hi6wghdkbb1z-firecracker-1.5.0/bin/firecracker [Firecracker VM binary]

Validating - CNI configuration requirements
        🔎 Searching - /etc/cni/conf.d
          ✅ Dependency Satisfied - /etc/cni/conf.d/fcnet.conflist [CNI Configuration]

Validating - User provided files
          ✅ Dependency Satisfied - /tmp/wd/vmlinux [VMLinux Kernel]
          ✅ Dependency Satisfied - /tmp/wd/rootfs.ext4 [Root Filesystem Template]
```

If prompted to download `User provided files` or to install the CNI configuration files you need to accept. This will
fetch a kernel and root filesystem and place them in `/tmp/wd` and place the CNI config for the firecracker vm in
`/etc/cni/conf.d/`.

With the precheck satisfied we can now fire up a Nex Node:

```terminal
❯ sudo -E nex --context ExpNode node up
time=2024-02-02T15:00:07.949Z level=INFO msg="Established node NATS connection" servers=""
time=2024-02-02T15:00:07.950Z level=INFO msg="Loaded node configuration from '%s'" config_path=./config.json
time=2024-02-02T15:00:07.950Z level=INFO msg="Use this key as the recipient for encrypted run requests" public_xkey=XAFF6MCEN32X4ZNU6UNR4GRSCMXGHTKQ2HCILI5QWLKFKTKQUFYVSN6U
time=2024-02-02T15:00:07.950Z level=INFO msg="Virtual machine manager starting"
time=2024-02-02T15:00:08.003Z level=INFO msg="Internal NATs server started" client_url=nats://0.0.0.0:45405
time=2024-02-02T15:00:08.003Z level=INFO msg="NATS execution engine awaiting commands" id=NCPJPBX62L6W6POO45PCEUANOVAWBLEZSRTF6JX5VVUIK25RX7ZSU4OX version=development
time=2024-02-02T15:00:08.087Z level=INFO msg="Called startVMM(), setting up a VMM" firecracker=true vmmid=cmug6u0mvb3362tsuc20 socket_path=/tmp/.firecracker.sock-2309935-cmug6u0mvb3362tsuc20
time=2024-02-02T15:00:08.098Z level=INFO msg="VMM metrics disabled." firecracker=true vmmid=cmug6u0mvb3362tsuc20
time=2024-02-02T15:00:08.099Z level=INFO msg=refreshMachineConfiguration firecracker=true vmmid=cmug6u0mvb3362tsuc20 err="[GET /machine-config][200] getMachineConfigurationOK  &{CPUTemplate: MemSizeMib:0xc0004d3e48 Smt:0xc0004d3e53 TrackDirtyPages:0xc0004d3e54 VcpuCount:0xc0004d3e40}"
time=2024-02-02T15:00:08.099Z level=INFO msg=PutGuestBootSource firecracker=true vmmid=cmug6u0mvb3362tsuc20 err="[PUT /boot-source][204] putGuestBootSourceNoContent "
time=2024-02-02T15:00:08.099Z level=INFO msg="Attaching drive" firecracker=true vmmid=cmug6u0mvb3362tsuc20 drive_path=/tmp/rootfs-cmug6u0mvb3362tsuc20.ext4 slot=1 root=true
time=2024-02-02T15:00:08.099Z level=INFO msg="Attached drive" firecracker=true vmmid=cmug6u0mvb3362tsuc20 drive_path=/tmp/rootfs-cmug6u0mvb3362tsuc20.ext4 err="[PUT /drives/{drive_id}][204] putGuestDriveByIdNoContent "
time=2024-02-02T15:00:08.099Z level=INFO msg="Attaching NIC at index" firecracker=true vmmid=cmug6u0mvb3362tsuc20 device_name=tap0 mac_addr=fe:17:3d:14:7c:d1 interface_id=1
time=2024-02-02T15:00:08.137Z level=INFO msg="startInstance successful" firecracker=true vmmid=cmug6u0mvb3362tsuc20 err="[PUT /actions][204] createSyncActionNoContent "
time=2024-02-02T15:00:08.137Z level=INFO msg="SetMetadata successful" firecracker=true vmmid=cmug6u0mvb3362tsuc20
time=2024-02-02T15:00:08.137Z level=INFO msg="Machine started" vmid=cmug6u0mvb3362tsuc20 ip=192.168.127.63 gateway=192.168.127.1 netmask=ffffff00 hosttap=tap0 nats_host=192.168.127.1 nats_port=45405
time=2024-02-02T15:00:08.137Z level=INFO msg="Adding new VM to warm pool" ip=192.168.127.63 vmid=cmug6u0mvb3362tsuc20
time=2024-02-02T15:00:09.138Z level=INFO msg="Received agent handshake" vmid=cmug6u0mvb3362tsuc20 message="Host-supplied metadata"
```

If this fails to receive an agent handshake within a short timeout, it will exit. The most likely reason is that your
firewall does not allow connections from `veth+` interfaces.

If you're running NixOS, add the following system config:

```nix
networking.firewall.trustedInterfaces = [ "veth+" ];
```

In a separate terminal we can now deploy the echo service:

```terminal
# build a static binary for the echo service
❯ ECHO_BIN=$(nix build --print-out-paths .#echo-service)/bin/echo

# the dev nats server uses JWT authentication, capture the JWT to be used by the service
❯ NATS_JWT=$($NSC_HOME/creds/Nex/Exp/EchoService.creds | head -n 2 | tail -n 1)

# deploy the service
❯ nex --context ExpAdmin devrun $ECHO_BIN NATS_URL=nats://192.168.127.1:4222 NATS_JWT=$NATS_JWT
Reusing existing issuer account key: /home/brian/.nex/issuer.nk
Reusing existing publisher xkey: /home/brian/.nex/publisher.xk
🚀 Workload 'echo' accepted. You can now refer to this workload with ID: cmugb00mvb37r9dpgs6g on node NCJG4N2ANO75CUV6TU3CU6ZHI3P24XCTXAD4MBCU5M2B2D7BHNDGEUVH%

# check the service is running
❯ nats --context ExpAdmin micro ls
╭──────────────────────────────────────────────────────────────╮
│                      All Micro Services                      │
├─────────────┬─────────┬────────────────────────┬─────────────┤
│ Name        │ Version │ ID                     │ Description │
├─────────────┼─────────┼────────────────────────┼─────────────┤
│ EchoService │ 1.0.0   │ hq6VycV72YTJRMWSPt0ZjX │             │
╰─────────────┴─────────┴────────────────────────┴─────────────╯

# send a request
❯ nats --context ExpAdmin req svc.echo 'hello'
15:11:55 Sending request on "svc.echo"
15:11:55 Received with rtt 266.233µs
hello

```

## License

This software is provided free under the [MIT Licence](https://opensource.org/licenses/MIT).

## Contact

There are a few different ways to reach me, all of which are listed on my [website](https://bmcgee.ie/).
