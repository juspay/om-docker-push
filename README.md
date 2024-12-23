# om-docker-push

A flake app to **build flake outputs on remote machine and push** `dockerImage` store paths [built by Omnix](https://omnix.page/om/ci.html) to cachix.

## Overview
This tool streamlines the process of:

1. Building flake outputs remotely using [`om ci`](https://omnix.page/om/ci.html)
2. Automatically transfers all build outputs back to the host machine via the result symlink.
3. Identifies and pushes only the dockerImage store paths to the specified [`Cachix`](https://cachix.org) cache.

## Prerequisites

- Nix with flakes enabled
- SSH access to the remote machine
- Cachix authentication token

## Usage

To use `om-docker-push`, run the following command:

```sh
nix run github:juspay/om-docker-push <FLAKE> <REMOTE_ADDRESS> <CACHE_NAME>
```
- \<FLAKE\>: The flake or sub-flake you wish to build. Can be a local flake (like .#dockerImage) or a remote one (like github:org/repo#someOutput).
- <REMOTE_ADDRESS>: The SSH address of the remote machine where the build will occur (e.g., user@hostname or user@ip).
- <CACHE_NAME>: The name of your Cachix cache where nix store paths will be pushed.

Example:

```sh
nix run github:juspay/om-docker-push .#dockerImage john@<IP> mycache
```

