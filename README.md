# Dotfiles

General settings that I have across multiple machines.

Below are the descriptions of the folders in the repo

## nixos/

This folder is symlinked to /etc/nixos

Install package into env temporarily `nix-env -i <pkg>`

Test out building a new version with `nixos-rebuild build --upgrade`

Update to new version with `sudo nixos-rebuild switch`

Clear old boot entries `sudo nix-collect-garbage --delete-older-than 14d`

Update boot entry with `sudo nixos-rebuild boot`

Format manually with `nixpkgs-fmt`

Nix home-manager is managed under configuration.nix and requires running nixos-rebuild as root
