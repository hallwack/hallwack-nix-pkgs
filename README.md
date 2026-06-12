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
