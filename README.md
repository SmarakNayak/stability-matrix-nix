# stability-matrix-nix

Nix package for the [StabilityMatrix](https://github.com/LykosAI/StabilityMatrix) AppImage, a multi-platform package manager for Stable Diffusion.

## Usage

### NixOS / Home Manager

Add to your flake inputs:

```nix
inputs.stability-matrix-nix.url = "github:SmarakNayak/stability-matrix-nix";
```

Then add the package:

```nix
environment.systemPackages = [
  inputs.stability-matrix-nix.packages.${system}.default
];
```

### One-off

```bash
nix run github:SmarakNayak/stability-matrix-nix
```

### Build locally

```bash
nix build
./result/bin/stability-matrix
```

## AppImage wrapper

This package wraps the official StabilityMatrix Linux AppImage using `appimageTools.wrapType2`. Note: the `appimageTools` API is marked unstable in nixpkgs and may change in future releases.

## Supported systems

Currently only `x86_64-linux` is supported, as StabilityMatrix only ships a Linux x64 binary. Support for additional systems (e.g. `aarch64-linux`) will be added if upstream provides builds for them.

## Updates

Version updates are automated via GitHub Actions — the update workflow runs hourly, bumps the version and hash in `package.nix`, updates `flake.lock`, builds to verify, and opens a PR that auto-merges on success.
