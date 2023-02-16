{ config, pkgs, nixpkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [
      ./hardware-configuration.nix
    ];
  users.users.mike = {
    isNormalUser = true;
    description = "Mike Kaliman";
    home = "/home/mike";
    extraGroups = [ "networkmanager" "dialout" "wheel" "docker" ];
  };
  # Alow unfree system packages
  nixpkgs.config = {
    allowUnfree = true;
  };


  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 60; # Seconds
      systemd-boot = {
        configurationLimit = 4;
        enable = true;
      };
    };
    kernelModules = [
      "iwlwifi"
      "kvm-amd"
    ];
  };

  # Attempts to address slow network startup
  # Source: https://majiehong.com/post/2021-07-30_slow_nixos_startup/
  systemd.services.NetworkManager-wait-online.enable = false;

  # I'm able to just use the monitor i care about for GDM by settings the gdm config
  # https://discourse.nixos.org/t/gdm-monitor-configuration/6356
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
      <!-- this should all be copied from your ~/.config/monitors.xml -->
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>2160</y>
            <scale>1</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>DP-0</connector>
                <vendor>SAM</vendor>
                <product>Odyssey G7</product>
                <serial>HCPW200123</serial>
              </monitorspec>
              <mode>
                <width>3840</width>
                <height>2160</height>
                <rate>120.000</rate>
              </mode>
            </monitor>
          </logicalmonitor>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>1</scale>
            <monitor>
              <monitorspec>
                <connector>DP-2</connector>
                <vendor>AUS</vendor>
                <product>ASUS VG289</product>
                <serial>0x000097e0</serial>
              </monitorspec>
              <mode>
                <width>3840</width>
                <height>2160</height>
                <rate>59.997</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    ''}"
  ];

  time.timeZone = "America/New_York";

  networking = {
    hostName = "desktop";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    networkmanager.enable = true;

    dhcpcd.wait = "background";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  hardware = {
    bluetooth.enable = true;
    # Needed for PipeWire-based PulseAudio
    pulseaudio.enable = false;
  };

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
    dbus.packages = [ pkgs.dconf ];
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
  };


  # pipewire setup https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    python3Full
    piper # Gaming mouse config
    gcc
    bat
    fzf
    ripgrep
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
    usbutils
    xsel
    xclip
    firefox
  ];
  environment.variables.EDITOR = "nvim";

  programs.mtr.enable = true;


  # TODO: set this within home-manager
  # I dont think this works
  #programs.bash.loginShellInit = ''
  #export XDG_DATA_DIRS=/home/mike/.nix-profile/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS
  # '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11";

}

