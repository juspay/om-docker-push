{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    omnix.url = "github:juspay/omnix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { config, self', pkgs, lib, system, ... }: {
        packages.default = pkgs.writeShellApplication {
          name = "om-docker-push";
          runtimeInputs = with pkgs; [ jq cachix ];
          text = ''
            if [[ $# -ne 3 ]]; then
              echo "Usage: $0 <FLAKE> <REMOTE_ADDRESS> <CACHE_NAME>"
              exit 1
            fi
            
            sub_flake="$1"
            remote_address="$2"
            cache_name="$3"

            ${lib.getExe inputs.omnix.packages.${system}.default} ci run --on ssh://"$remote_address" "$sub_flake#dockerImage"

            DOCKERIMAGE=$(jq -r '.result.ROOT.build.byName | to_entries[] | select(.key | test("^docker-image-.*$")) | .value' < result)
            echo "Pushing DockerImage binaries to $cache_name.cachix.org"
            echo "$DOCKERIMAGE"
            cachix push "$cache_name" "$DOCKERIMAGE"

          '';
        };

        apps.default = {
          type = "app";
          program = "${lib.getExe self'.packages.default}";
        };
      };
    };
}
