# hallwack-nix-pkgs ❄️

Welcome to my personal [Nix User Repository (NUR)](https://github.com/nix-community/NUR) and Nix Flake. This repository contains a collection of custom software packages and derivation recipes for NixOS.

## 📦 Available Packages

Currently, this repository provides the following packages:

* **`zennotes`**: Keyboard-first local Markdown notes.
* **`helium-browser`**: A lightweight, floating browser window for multitasking.

*(More packages will be added in the future as needed).*

## 🚀 Usage

You can install or run the packages from this repository using either the official NUR index or directly via Nix Flakes.

### Option 1: Via NUR (Nix User Repository)

If you have NUR configured in your NixOS setup, you can access the packages under the `hallwack` namespace:

```nix
# In your configuration.nix or home.nix
environment.systemPackages = with pkgs; [
  nur.repos.hallwack.zennotes
  nur.repos.hallwack.helium-browser
];
```

### Option 2: Via Nix Flakes

If you are using a modern Nix setup with Flakes enabled, you can add this repository as an input to your system configuration.

1. Add to inputs in your flake.nix:

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
  # Add this repository as an input
  hallnix.url = "github:hallwack/hallnix-pkgs";
};
```

2. Call the package in your configuration:

```nix
outputs = { self, nixpkgs, hallnix, ... }: {
  nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ pkgs, ... }: {
        environment.systemPackages = [
          # Install the packages
          hallnix.packages.${pkgs.system}.zennotes
          hallnix.packages.${pkgs.system}.helium-browser
        ];
      })
      # ... other system modules ...
    ];
  };
};
```

### Option 3: Try it without installing (nix run)

You can temporarily run the applications without installing them globally into your system:

```bash
nix run github:hallwack/hallnix-pkgs#zennotes
nix run github:hallwack/hallnix-pkgs#helium-browser
```

## 🤖 Maintenance & Auto-Updates

This repository uses GitHub Actions and nix-update to automatically track upstream releases.

Updates are scheduled to be checked daily.

SRI hashes (sha256) are calculated and updated automatically via Pull Requests.

## 📄 License

The Nix expressions in this repository are licensed under the MIT License. The software packages themselves are subject to their respective upstream licenses.
