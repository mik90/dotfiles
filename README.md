# Dotfiles

General settings that I have across multiple machines.

Below are the descriptions of the folders in the repo

## Cheat sheet

Install package into env temporarily `nix-env -i <pkg>`

Test out building a new version with `nixos-rebuild build --upgrade`

Update to new version with `sudo nixos-rebuild switch`. Also updates the boot entry

Clear old boot entries `sudo nix-collect-garbage --delete-older-than 14d`

Format manually with `nixpkgs-fmt`

Nix home-manager is managed under configuration.nix and requires running nixos-rebuild as root

## framework-nixos/

NixOS install for my framework laptop

`/etc/nixos` is symlinked to this folder. e.g. sudo ln -sv  `/path/to/this/folder/framework-nixos /etc/nixos`

## desktop-nixos/

NixOS install for my desktop's linux partition

`/etc/nixos` is symlinked to this folder.  e.g. sudo ln -sv  `/path/to/this/folder/desktop-nixos /etc/nixos`

