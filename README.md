# stability-matrix-nix

Nix package for [StabilityMatrix](https://github.com/LykosAI/StabilityMatrix), a multi-platform package manager for Stable Diffusion.

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

## Updates

Version updates are automated via GitHub Actions — the update workflow runs hourly, bumps the version and hash in `package.nix`, updates `flake.lock`, builds to verify, and opens a PR that auto-merges on success.
