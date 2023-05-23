# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./obs.nix
      # ./nvidia.nix # Not working on wayland
    ];

  nix = {
    settings = {
      # Enable flakes and new `nix` command
      experimental-features = [ "nix-command" "flakes"];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20; # don't show more than 10 entries
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixal"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nertsal = {
    isNormalUser = true;
    shell = pkgs.fish; # Default shell
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user
      "video" # To adjust screen brightness
      "input" # To read keyboard input
    ];
    packages = with pkgs; [
      firefox # Browser
      brave # Browser because firefox is bad sometimes
      tdesktop # Telegram
      gimp # Image editor
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch # NixOS btw
    killall # Wonder what's this for...
    pavucontrol # Audio control gui
    brightnessctl # Regulate screen brightness
    waybar # Wayland bar
    swaylock # Wayland locker
    # bemenu # Dynamic menu library
    wofi # Dynamic menu library
    linux-wifi-hotspot # Easy hotspot gui
    grim # Screenshot backend
    slurp # Region selection utility
    gscreenshot # Screenshot utility
    tealdeer # Fast `tldr` - short `man`
    neovim # Text editor
    helix # Text editor
    wget
    alacritty # Terminal
    kitty # Hyprland default terminal
    wl-clipboard # Wayland clipboard
    cava # Audio visualizer
    git
    lazygit # Simple git tui
    lsd # `ls` with nerdcons
    exa # The real `ls`
    bat # `cat` with wings
    bottom # Bottom to top
    fd # User-friendly find
    xh # Friendly curl
    xxh # Bring your shell through ssh
    erdtree # File-tree visualizer and disk usage analyzer
    felix-fm # Tui file manager
    ripgrep # Grep the rip
    topgrade # Update everything
    kondo # Cleaner after you upgrade everything
    tokei # Scan project languages and lines of code
    bacon # Background rust code checker
    just # Just a command runner
    # irust # Rust repl
    cargo-info # Fetch info about rust crates
    speedtest-rs # Speedtest cli
    wiki-tui # Wiki tui
    rustup # Rust toolchain manager
  ];

  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];

  # Pick only one of the below networking options.
  # Using wpa_supplicant because of wpa-eap (see right below)
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Enables wireless support via wpa_supplicant.
  networking.wireless = {
    enable = false;
    # Allow configuration via `wpa_gui` and `wpa_cli`
    # (user must also be part of `wheel` group)
    # userControlled.enable = true;
    # Allow insecure ciphers for WPA2-EAP institutional network connection
    # extraConfig = ''
    #   openssl_ciphers=DEFAULT@SECLEVEL=0
    # '';
  };

  # Fix time for dual-booting Windows
  time.hardwareClockInLocalTime = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable GNOME display manager
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # environment.gnome.excludePackages = (with pkgs; [
  #   gnome-photos
  #   gnome-tour
  # ]) ++ (with pkgs.gnome; [
  #   cheese
  #   gnome-music
  #   gnome-terminal
  #   gedit
  #   epiphany
  #   geary
  #   evince
  #   gnome-characters
  #   totem
  #   tali
  #   iagno
  #   hitori
  #   atomix
  # ]);

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true; # For nvidia to work properly
  };

  nixpkgs.overlays = [
    # Waybar experimental features
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  # Swaylock pam
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
  };
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Pipewire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Wifi hotspot configuration
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "enp59s0";
      WIFI_IFACE = "wlp0s20f3";
      SSID = "NertsalWifi";
      PASSPHRASE = "19283746";
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

