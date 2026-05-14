# Dotfiles

A minimalist, personal collection of configuration files optimized for a
resource-efficient workflow across Linux.

## Overview

This repository manages my core terminal environment and tooling configurations.
It relies on [GNU Stow](https://www.gnu.org/software/stow/) to handle symlinking
these configuration files directly into the home directory, keeping the system
clean and the dotfiles easily version-controlled.

## Prerequisites

Before deploying, ensure the following are installed on your system:

- `git`
- `stow`

## Installation

The `forge` script handles symlinking on any distro. On Arch it also drives a
`pacman` install of the package list; on NixOS it skips that step (packages
belong in your flake / `configuration.nix`) and just runs `stow` + Antidote.

1.  **Clone the repository** into your home directory:

    ```bash
    git clone https://github.com/singhc7/dotfiles ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Execute the forge script:**
    ```bash
    ./forge
    ```

### NixOS notes

- Declare packages (`git`, `stow`, `zsh`, `kitty`, `neovim`, `eza`, `fzf`,
  `zoxide`, `tealdeer`, …) in your system flake or `configuration.nix`.
- If Antidote is provided by the system (e.g. `programs.zsh.antidote` or the
  `antidote` package), `forge` will detect it at
  `/run/current-system/sw/share/antidote` and skip the user-level clone.

### Manual Installation

If you'd rather not run `forge`, deploy individual configs with stow:

```bash
stow zsh
stow kitty
```

_Stow creates symlinks from this repo into your home directory._

## License and Usage

This repository and its configurations are dual-licensed under two
non-commercial licenses. You may choose to use this work under the terms of
either:

1.  **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
    (CC BY-NC-SA 4.0)**
    - Best for sharing with the open-source community.
    - Requires attribution and sharing your own changes under the same license.
    - Prohibits commercial use.
2.  **PolyForm Noncommercial License 1.0.0**
    - Best for clear, modern legal protection.
    - Explicitly defines "non-commercial" to protect property rights.
    - Prohibits commercial use without a separate, negotiated license.

I believe in sharing knowledge and highly optimized workflows, but I also
strictly protect my property rights. Here is exactly what that means for you:

- **For Individuals (Free):** You are fully encouraged to clone, modify, and run
  these dotfiles for your personal study, hobby projects, private entertainment,
  and amateur pursuits. Use by educational institutions and charitable
  organizations is also completely free and permitted.
- **For Commercial Entities (Restricted):** You may **not** incorporate these
  configurations into any paid product, commercial service, or internal
  corporate environment.

The baseline is simple: if a price tag gets attached to my work, I am the one
who gets paid. If you wish to use this setup for commercial purposes, you must
contact me directly to negotiate a separate, paid commercial license.

See the full legal terms in the [LICENSE](LICENSE) file.
