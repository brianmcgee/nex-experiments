{lib, ...}: {
  perSystem = {pkgs, ...}: let
    config = pkgs.writeTextFile {
      name = "nats.conf";
      text = ''
        ## Default NATS server configuration (see: https://docs.nats.io/running-a-nats-service/configuration)

        ## Port for client connections.
        port: 4222

        ## Port for monitoring
        http_port: 8222

        client_advertise: 192.168.127.1:4222

        ## Configuration map for JetStream.
        ## see: https://docs.nats.io/running-a-nats-service/configuration#jetstream
        jetstream {}

        # include paths must be relative so for simplicity we just read in the auth.conf file
        include './auth.conf'
      '';
    };
  in {
    config.process-compose = {
      dev.settings.processes = {
        nats-server = {
          working_dir = "$NATS_HOME";
          command = ''${lib.getExe pkgs.nats-server} -c ./nats.conf -D -sd ./'';
          readiness_probe = {
            http_get = {
              host = "127.0.0.1";
              port = 8222;
              path = "/healthz";
            };
            initial_delay_seconds = 2;
          };
        };
        nats-setup = {
          depends_on.nats-server.condition = "process_healthy";
          # ensures contexts are generated in the .data directory
          environment.XDG_CONFIG_HOME = "$PRJ_DATA_DIR";
          command = pkgs.writeShellApplication {
            name = "nats-setup";
            runtimeInputs = with pkgs; [jq nsc];
            text = ''
              # create account and enable jetstream
              nsc add account -n Exp

              nsc edit account -n Exp \
                --js-mem-storage -1 \
                --js-disk-storage -1 \
                --js-streams -1 \
                --js-consumer -1

              # add some users
              nsc add user -a Exp -n Admin
              nsc add user -a Exp -n Node
              nsc add user -a Exp -n EchoService --bearer

              # push accounts to the server
              nsc push

              # create some contexts to make the cli easier to work with
              nsc generate context -a SYS -u sys --context Sys
              nsc generate context -a Exp -u Admin --context ExpAdmin
              nsc generate context -a Exp -u Node --context ExpNode
            '';
          };
        };
      };
    };

    config.devshells.default = {
      devshell.startup = {
        setup-nats = {
          text = ''
            set -euo pipefail

            # we only setup the data dir if it doesn't exist
            # to refresh simply delete the directory and run `direnv reload`
            [ -d $NSC_HOME ] && exit 0

            mkdir -p $NSC_HOME

            # initialise nsc state

            nsc init -n Nex --dir $NSC_HOME
            nsc edit operator \
                --service-url nats://localhost:4222 \
                --account-jwt-server-url nats://localhost:4222

            # setup server config

            mkdir -p $NATS_HOME
            cp ${config} "$NATS_HOME/nats.conf"
            nsc generate config --nats-resolver --config-file "$NATS_HOME/auth.conf"
          '';
        };
      };

      env = [
        {
          name = "NATS_HOME";
          eval = "$PRJ_DATA_DIR/nats";
        }
        {
          name = "NSC_HOME";
          eval = "$PRJ_DATA_DIR/nsc";
        }
        {
          name = "NKEYS_PATH";
          eval = "$NSC_HOME";
        }
        {
          name = "NATS_JWT_DIR";
          eval = "$PRJ_DATA_DIR/nats/jwt";
        }
      ];

      packages = [
        pkgs.nkeys
        pkgs.nats-top
      ];

      commands = let
        category = "synadia";
      in [
        # customise the nsc and nats commands to lock their state into the .data directory
        {
          name = "nsc";
          inherit category;
          help = "creates NATS operators, accounts, users, and manage their permissions";
          command = ''XDG_CONFIG_HOME=$PRJ_DATA_DIR ${pkgs.nsc}/bin/nsc -H "$NSC_HOME" "$@"'';
        }
        {
          name = "nats";
          inherit category;
          help = "NATS Server and JetStream administration";
          command = ''XDG_CONFIG_HOME=$PRJ_DATA_DIR ${pkgs.natscli}/bin/nats "$@"'';
        }
      ];
    };
  };
}
