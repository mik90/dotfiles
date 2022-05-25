{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.username = "mike";
  home.homeDirectory = "/home/mike";
  imports = [ ./dconf.nix ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.packages = [
    pkgs.htop
    pkgs.nixpkgs-fmt
    pkgs.yarn
  ];

  programs.git = {
    enable = true;
    userName = "Mike Kaliman";
    userEmail = "kaliman.mike@gmail.com";
  };
}
