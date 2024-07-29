# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./obs.nix
      ./nvidia.nix # Partially working on wayland
    ];

  nix = {
    settings = {
      # Enable flakes and new `nix` command
      experimental-features = [ "nix-command" "flakes"];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # limit number of entries
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixal"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nertsal = {
    isNormalUser = true;
    shell = pkgs.fish; # Default shell
    extraGroups = [
      "networkmanager"
      "wheel" # Enable ‘sudo’ for the user
      "video" # To adjust screen brightness
      "input" # To read keyboard input
      "docker" # Note: makes the user effectively root
    ];
    packages = with pkgs; [
      # Moved to home-manager
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
    wlr-randr # `xrandr` for wayland

    firefox # Web browser (global because of opengl being global)
    chromium # Because sometimes firefox doesn't work

    grim # Screenshot backend
    slurp # Region selection utility

    # Text editors
    neovim
    helix
    micro

    tealdeer # Fast `tldr` - short `man`
    wget
    alacritty # Terminal
    kitty # Hyprland default terminal
    wl-clipboard # Wayland clipboard
    cava # Audio visualizer

    git
    lazygit # Simple git tui
    act # Run CI locally (requires docker)

    zip
    unzip
    lsd # `ls` with nerdcons
    eza # The real `ls` (fork of exa)
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
    speedtest-rs # Speedtest cli
    wiki-tui # Wiki tui
    cargo-info # Fetch info about rust crates
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
  services.xserver = {
    enable = true;

    displayManager.gdm.enable = true;

    displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1-1 --pos 0x0 --rate 60.02 --mode 1920x1080 --output HDMI-0 --pos 1920x0 --rate 119.98 --primary --mode 1920x1080
    '';

    # GNOME
    desktopManager.gnome.enable = true;

    # LeftWM
    windowManager.leftwm.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us,ru";
      options = "grp:alt_shift_toggle";
    };
  };

  services.libinput = {
    enable = true;

    mouse = {
      accelProfile = "flat";
      accelSpeed = "-0.32";
    };

    touchpad = {
      accelProfile = "flat";
    };
  };

  # Minimal Gnome
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    cheese
    gnome-terminal
    epiphany
    geary
    evince
    totem
  ]) ++ (with pkgs.gnome; [
    gnome-music
    gnome-characters
    tali
    iagno
    hitori
    atomix
  ]);

  # Locker
  programs.slock = {
    enable = true;
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;

  # Pipewire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    extraConfig.pipewire."stutter-fix" = {
      context.properties = {
        default.clock.min-quantum = 512; # Fix audio stutter
      };
    };
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # For osu!
  hardware.opentabletdriver.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # networking.dhcpcd.allowInterfaces = [ "enp59s0" "wlp0s20f3" ];
  # networking.interfaces.enp59s0.useDHCP = true;
  # networking.interfaces.wlp0s20f3.useDHCP = true;

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

