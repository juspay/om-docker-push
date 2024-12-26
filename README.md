# om-docker-push

A flake app to **build dockerImage and push** store paths to cachix.

## Overview
This tool streamlines the process of:

1. Building flake output `dockerImage`.
2. Pushes the dockerImage store paths to the specified [`Cachix`](https://cachix.org) cache.

## Prerequisites

- SSH access to the remote machine
- Nix with flakes enabled
- Cachix authentication token

## Usage

To use `om-docker-push`, run the following command:

First, connect to the remote machine using

```sh
ssh <USER>@<IP>
```

And then run the following command to run `om-docker-push`

```sh
nix run github:juspay/om-docker-push <PROJECT> <BRANCH> <COMMIT> <CACHE_NAME>
```
where
- \<PROJECT\>: The name of Project(Bitbucket) + Repository name. For example, `jbiz/euler-api-order`
- \<BRANCH\>: Name of the branch.
- \<COMMIT\>: Commit respect to which build needs to run.
- <CACHE_NAME>: The name of your Cachix cache where nix store paths will be pushed.

Example:

```sh
nix run github:juspay/om-docker-push jbiz/euler-api-order main 581176066fbd18906443e463283fjfj982js09j mycache
```

