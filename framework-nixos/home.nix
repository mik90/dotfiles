{ config, lib, pkgs, ... }:
{
    home.username = "mike";
    home.homeDirectory = "/home/mike";

    # Alow unfree home-manager packages
    nixpkgs.config = {
      allowUnfree = true;
    };

    programs.bash.enable = true;

    home.packages = [
      htop
      neofetch
      nixpkgs-fmt
      yarn
      discord
      vlc
    ];
    xdg.configFile."nvim/init.vim".source = dotfiles/neovim/init.vim;

    programs.git = {
      enable = true;
      userName = "Mike Kaliman";
      userEmail = "kaliman.mike@gmail.com";
    };
    dconf.settings = {
      # Set dark mode with `gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark`
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
      };
      # Use min/max/close for the window titlebar
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
      };
      # Turns off terminal bell sound in firefox, kinda sounds like "boink" tbh
      # https://unix.stackexchange.com/a/444869
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
    };
}