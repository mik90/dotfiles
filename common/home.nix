{ config, lib, pkgs, ... }:
{

  home.username = "mike";
  home.homeDirectory = "/home/mike";

  # Alow unfree home-manager packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    htop
    neofetch
    nixpkgs-fmt
    cmake
    conan
    ninja
    yarn
    discord
    vlc
  ];
  dconf.enable = true;
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
  programs.git = {
    enable = true;
    userName = "Mike Kaliman";
    userEmail = "kaliman.mike@gmail.com";
  };


  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
        vim-nix
        indentLine
        nvim-lspconfig
    ];
  };

  xdg.configFile."nvim/init.vim".text = ''
    set shiftwidth=2
    set softtabstop=2
    set backspace=indent,eol,start
    set ruler
    set number
    set relativenumber
    set noexpandtab
    set nohlsearch

    let g:indentLine_leadingSpaceChar='·'
    let g:indentLine_leadingSpaceEnabled=1

    autocmd filetype makefile setlocal noexpandtab 
    autocmd filetype python setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4
    autocmd filetype java setlocal expandtab 
    autocmd filetype cpp setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4 
    autocmd filetype markdown setlocal expandtab 
    autocmd filetype sh setlocal expandtab 
    autocmd filetype cmake setlocal expandtab 
  '';
}
