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

  # TODO
  # May need this in order to get LHS monitor working in GDM
  # https://discourse.nixos.org/t/gdm-monitor-configuration/6356
  /*
    systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
    <!-- this should all be copied from your ~/.config/monitors.xml -->
    <monitors version="2">
    <configuration>
    <!-- REDACTED -->
    </configuration>
    </monitors>
    ''}"
    ];
  */
  # Working xrandr output:
  /*
    Screen 0: minimum 8 x 8, current 7680 x 2160, maximum 32767 x 32767
    DVI-D-0 disconnected (normal left inverted right x axis y axis)
    HDMI-0 connected 3840x2160+0+0 (normal left inverted right x axis y axis) 621mm x 341mm
    3840x2160     60.00*+  59.94    50.00    29.97    25.00    23.98  
    2560x1440     59.95  
    1920x1080     60.00    59.94    50.00    23.98  
    1680x1050     59.95  
    1440x900      59.89  
    1440x576      50.00  
    1440x480      59.94  
    1280x1024     60.02  
    1280x960      60.00  
    1280x800      59.81  
    1280x720      60.00    59.94    50.00  
    1024x768      60.00  
    800x600       60.32    56.25  
    720x576       50.00  
    720x480       59.94  
    640x480       59.94    59.93  
    DP-0 disconnected (normal left inverted right x axis y axis)
    DP-1 disconnected (normal left inverted right x axis y axis)
    HDMI-1 connected primary 3840x2160+3840+0 (normal left inverted right x axis y axis) 621mm x 341mm
    3840x2160     60.00*+  59.94    50.00    29.97    25.00    23.98  
    2560x1440     59.95  
    1920x1080     60.00    59.94    50.00    23.98  
    1680x1050     59.95  
    1440x900      59.89  
    1440x576      50.00  
    1440x480      59.94  
    1280x1024     60.02  
    1280x960      60.00  
    1280x800      59.81  
    1280x720      60.00    59.94    50.00  
    1024x768      60.00  
    800x600       60.32    56.25  
    720x576       50.00  
    720x480       59.94  
    640x480       59.94    59.93  
  */


  networking.hostName = "nixos";
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.flatpak.enable = true;
  services.openssh.enable = true;

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



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

