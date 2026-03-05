# Dotfiles

A minimalist, personal collection of configuration files optimized for a resource-efficient workflow across Fedora Linux and macOS. 

## Overview
This repository manages my core terminal environment and tooling configurations. It relies on [GNU Stow](https://www.gnu.org/software/stow/) to handle symlinking these configuration files directly into the home directory, keeping the system clean and the dotfiles easily version-controlled.


## Prerequisites
Before deploying, ensure the following are installed on your system:
* `git`
* `stow`

## Installation

1. **Clone the repository** into your home directory:

        git clone https://github.com/singhc7/dotfiles.git ~/.dotfiles
        cd ~/.dotfiles

2. **Deploy configurations** using Stow. Run this command for each piece of software you want to configure:

        stow zsh
        stow alacritty

*Note: Stow will automatically create symlinks from the folders in this repository to their appropriate locations in your home directory.*

## License and Usage

This repository and its configurations are licensed under the **PolyForm Noncommercial License 1.0.0**. 

I believe in sharing knowledge and highly optimized workflows, but I also strictly protect my property rights. Here is exactly what that means for you:

* **For Individuals (Free):** You are fully encouraged to clone, modify, and run these dotfiles for your personal study, hobby projects, private entertainment, and amateur pursuits. Use by educational institutions and charitable organizations is also completely free and permitted. 
* **For Commercial Entities (Restricted):** You may **not** incorporate these configurations into any paid product, commercial service, or internal corporate environment. 

The baseline is simple: if a price tag gets attached to my work, I am the one who gets paid. If you wish to use this setup for commercial purposes, you must contact me directly to negotiate a separate, paid commercial license.

See the full legal terms in the [LICENSE](LICENSE) file.
