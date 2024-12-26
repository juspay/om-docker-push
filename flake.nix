{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { config, self', pkgs, lib, system, ... }: {
        packages.default = pkgs.writeShellApplication {
          name = "om-docker-push";
          runtimeInputs = with pkgs; [ jq cachix ];
          text = ''
            if [[ $# -ne 4 ]]; then
              echo "Usage: $0 <PROJECT> <BRANCH> <COMMIT> <CACHE_NAME>"
              exit 1
            fi
            
            project="$1"
            branch="$2"
            commit="$3"
            cache_name="$4"

            FLAKE="git+ssh://git@ssh.bitbucket.juspay.net/$project?ref=$branch&rev=$commit"
            DOCKERIMAGE=$(nix build --no-link --print-out-paths "$FLAKE"#dockerImage)
            echo "Pushing Store Paths for Docker Image"
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
