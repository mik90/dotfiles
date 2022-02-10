{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  nixpkgs.config.allowUnfree = true;

  users.users.eve.isNormalUser = true;
  home-manager.users.mike = { pkgs, ... }: {
    home.packages = [ ]; # e.g. pkgs.atool pkgs.httpie
    programs.bash.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      configurationLimit = 4;
      useOSProber = true;
    };
    systemd-boot = {
      enable = true;
    };
  };
  # Unsure if this overides boot.kernelModules in hardware-configuration.nix entirely or just appends to it
  boot.kernelModules = [
    "iwlwifi"
    "kvm-amd"
  ];


  networking.hostName = "nixos";
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp12s0f3u2u1i5.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.flatpak.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      videoDrivers = [ "nvidia" ];
      layout = "us";
      libinput.enable = true;
    };

    # https://gvolpe.com/blog/gnome3-on-nixos/
    # Set dark mode with `gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark`
    dbus.packages = [ pkgs.gnome3.dconf ];
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.mike = {
    isNormalUser = true;
    home = "/home/mike";
    description = "Mike Kaliman";
    extraGroups = [
      "wheel"
      "dailout"
      "networkmanager"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    python3Full
    gcc
    binutils-unwrapped
    clang
    clang-tools
    rustup
    vscode
    bitwarden
    pciutils
    wget
    firefox
    home-manager
  ];
  environment.variables.EDITOR = "nvim";

  programs.mtr.enable = true;


  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      # TODO: Get this rc to work
      customRC = ''
        set shiftwidth=2
        set softtabstop=2
        set backspace=indent,eol,start
        set ruler
        set number
        set relativenumber
        set noexpandtab
        set nohlsearch
      
        highlight CursorLine cterm=none ctermbg=235
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
      packages.nix.start = with pkgs.vimPlugins; [ vim-nix indentLine ];
    };

  };


  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

