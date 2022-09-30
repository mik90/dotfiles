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
      pkgs.neofetch
      pkgs.nixpkgs-fmt
      pkgs.yarn
      pkgs.discord
      pkgs.vlc
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
  users.users.mike = {
    isNormalUser = true;
    description = "Mike Kaliman";
    extraGroups = [ "networkmanager" "dialout" "wheel" ];
  };


  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  
  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 4;
      consoleMode = "auto";
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  systemd.tmpfiles.rules = [
    # Load up a monitors.xml so that GDM uses the correct resolution
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
        <monitors version="2">
          <configuration>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>eDP-1</connector>
                  <vendor>BOE</vendor>
                  <product>0x095f</product>
                  <serial>0x00000000</serial>
                </monitorspec>
                <mode>
                  <width>2256</width>
                  <height>1504</height>
                  <rate>59.998512268066406</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
    ''}"
  ];

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
    # Hopefully -wayland will handle the black firefox on startup
    # https://discourse.nixos.org/t/firefox-all-black-when-first-launched-after-login/21143/7?u=m_mike
    firefox-wayland
    google-chrome
    vscode
    bitwarden
    pciutils
    usbutils
    xsel
    xclip
    wget
  ];
  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 5000;
    baseIndex = 1;
    shortcut = "a";
    terminal = "screen-256color";
    extraConfig = ''
      # A lot of these settings are pulled from https://github.com/gpakosz/.tmux

      # Allow scrolling
      set -g mouse on

      bind Enter copy-mode # enter copy mode

      run -b 'tmux bind -t vi-copy v begin-selection 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi v send -X begin-selection 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy C-v rectangle-toggle 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi C-v send -X rectangle-toggle 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy y copy-selection 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi y send -X copy-selection-and-cancel 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy Escape cancel 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi Escape send -X cancel 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy H start-of-line 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi H send -X start-of-line 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy L end-of-line 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi L send -X end-of-line 2> /dev/null || true'

      
      # Ripped from https://unix.stackexchange.com/a/318285
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
      bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
      bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
      bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

      # Use vi bindings in copy mode
      setw -g mode-keys vi
      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection c"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      
      bind Enter copy-mode # enter copy mode

      bind b list-buffers  # list paste buffers
      bind p paste-buffer  # paste from the top paste buffer
      bind P choose-buffer # choose which buffer to paste from

      # split current window horizontally
      bind - split-window -v
      bind _ split-window -v
      # split current window vertically
      bind | split-window -h
    '';
  };

  programs.bash = {
    interactiveShellInit = ''
      # cd but marginally more helpful
      # The gist of it:
      #```bash
      #  user@host:~$ cd /some/deep/nested/path
      #  user@host:/some/deep/nested/path$
      #  user@host:/some/deep/nested/path$ cdu deep
      #  user@host:/some/deep
      # ```

      # cd up to n dirs
      # using:  cd.. 10   cd.. dir
      # src: https://stackoverflow.com/a/26134858/15827495
      function _zz_cd_up() {
        case $1 in
          *[!0-9]*)                                          # if no a number
            cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" )     # search dir_name in current path, if found - cd to it
            ;;                                               # if not found - not cd
          *)
            cd $(printf "%0.0s../" $(seq 1 $1));             # cd ../../../../  (N dirs)
          ;;
        esac
      }

      alias 'cdu'='_zz_cd_up'                                # can not name function 'cd..'
    '';
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
