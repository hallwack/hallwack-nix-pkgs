# hallwack-nix-pkgs ❄️

A personal collection of Nix packages and Flakes maintained by Hallwack.

This repository provides custom package definitions for software that may not yet be available in nixpkgs or that require newer releases than those currently packaged upstream.

## 📦 Available Packages

| Package          | Description                                                            |
| ---------------- | ---------------------------------------------------------------------- |
| `zennotes`       | Keyboard-first local Markdown notes application.                       |
| `helium-browser` | Lightweight floating browser window for distraction-free multitasking. |

More packages may be added over time as needed.

---

## 🚀 Quick Start

Run an application directly without installing it:

### Zennotes

```bash
nix run github:hallwack/hallwack-nix-pkgs#zennotes
```

### Helium Browser

```bash
nix run github:hallwack/hallwack-nix-pkgs#helium-browser
```

---

## 📥 Using as a Flake Input

Add this repository as a flake input:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hallnix.url = "github:hallwack/hallwack-nix-pkgs";
  };
}
```

Then install packages from the flake:

```nix
{
  outputs = { self, nixpkgs, hallnix, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            hallnix.packages.${pkgs.system}.zennotes
            hallnix.packages.${pkgs.system}.helium-browser
          ];
        })
      ];
    };
  };
}
```

### Home Manager

```nix
{
  home.packages = [
    hallnix.packages.${pkgs.system}.zennotes
    hallnix.packages.${pkgs.system}.helium-browser
  ];
}
```

---

## 🔨 Development

Build packages locally:

### Build Zennotes

```bash
nix build .#zennotes
```

### Build Helium Browser

```bash
nix build .#helium-browser
```

Run package checks:

```bash
nix flake check
```

---

## 🖥 Supported Systems

The following systems are currently supported:

- x86_64-linux
- aarch64-linux

Support depends on upstream application availability.

---

## 🤖 Automated Updates

This repository uses GitHub Actions together with `nix-update` to help track upstream releases.

The update workflow:

- Checks upstream releases on a regular schedule
- Updates package versions automatically
- Recalculates SRI hashes when required
- Creates pull requests for review

Automatic updates are intended to reduce maintenance effort while keeping packages reasonably up to date.

---

## 📁 Repository Structure

```text
.
├── flake.nix
├── pkgs
│   ├── helium-browser
│   └── zennotes
└── README.md
```

---

## 🤝 Contributing

Issues, bug reports, and package suggestions are welcome.

If you encounter packaging issues or upstream changes that break a package, please open an issue or submit a pull request.

---

## 📄 License

The Nix expressions and repository contents are licensed under the MIT License unless otherwise stated.

Packaged software remains subject to its respective upstream license terms.
