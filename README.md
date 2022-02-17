# Dotfiles

General settings that I have across multiple machines.

## nixos/

Symlinked to /etc/nixos

Update to new version with `sudo nixos-rebuild switch`

Clear old boot entries `sudo nix-collect-garbage --delete-older-than 14d`

Update boot entry with `sudo nixos-rebuild boot`

## home-manager

Nix home manager <https://nix-community.github.io/home-manager/index.html>
Symlinked to ~/.config/nixpkgs

Update to new version with `home-manager switch`
