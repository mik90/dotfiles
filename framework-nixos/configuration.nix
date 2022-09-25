{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
  home-manager.users.mike = { pkgs, ... }: {
    # Alow unfree home-manager packages
    nixpkgs.config = {
      allowUnfree = true;
    };
    programs.bash.enable = true;
    home.packages = [
      pkgs.htop
      pkgs.nixpkgs-fmt
      pkgs.yarn
      pkgs.discord
    ];
    home.username = "mike";
    home.homeDirectory = "/home/mike";
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
  };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";


  # Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    ratbagd.enable = true; # needed for piper (gaming mouse configurator)
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # enable jack applications, not really needed
      jack.enable = true;
    };
    # https://gvolpe.com/blog/gnome3-on-nixos/
    # Set dark mode with `gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark`
    dbus.packages = [ pkgs.dconf ];
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
  };

  users.users.mike = {
    isNormalUser = true;
    description = "Mike Kaliman";
    extraGroups = [ "networkmanager" "dialout" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    python3Full
    piper # Gaming mouse config
    gcc
    binutils-unwrapped
    clang
    clang-tools
    upower
    htop
    rustup
    vscode
    bitwarden
    pciutils
    wget
    firefox
    home-manager
  ];
  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      packages.nix.start = with pkgs.vimPlugins; [ vim-nix indentLine ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
