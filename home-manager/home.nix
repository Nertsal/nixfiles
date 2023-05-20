{ config, pkgs, inputs, ... }:

let
  # 'onedarker'
  # <https://github.com/helix-editor/helix/blob/master/runtime/themes/onedarker.toml>
  mainColors = {
    yellow = "#d5b06b";
    blue = "#519fdf";
    red = "#d05c65";
    purple = "#b668cd";
    green = "#7da869";
    gold = "#d19a66";
    cyan = "#46a6b2";
    white = "#abb2bf";
    black = "#16181a";
    light-black = "#2c323c";
    gray = "#252d30";
    faint-gray = "#abb2bf";
    light-gray = "#636c6e";
    linenr = "#282c34";
  };
in
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "nertsal";
    homeDirectory = "/home/nertsal";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./shell.nix
  ];

  # inputs.nix-colors.colorSchemes.icy
  # Set color scheme for use in configs
  colorScheme = {
    slug = "nertdarker";
    name = "NertDarker";
    author = "Nertsal";
    colors = {
      base00 = "#081012"; # "#081012"; # black
      base01 = "#abb2bf"; # "#353b45"; # ?
      base02 = "#252d30"; # "#3e4451"; # gray
      base03 = "#545862"; # "#545862"; # ?
      base04 = "#565c64"; # "#565c64"; # ?
      base05 = "#abb2bf"; # "#abb2bf"; # white
      base06 = "#b6bdca"; # "#b6bdca"; # ?
      base07 = "#c8ccd4"; # "#c8ccd4"; # purple?
      base08 = "#d05c65"; # "#e06c75"; # red
      base09 = "#d19a66"; # "#d19a66"; # gold
      base0A = "#d5b06b"; # "#e5c07b"; # yellow
      base0B = "#7da869"; # "#98c379"; # green
      base0C = "#46a6b2"; # "#56b6c2"; # cyan
      base0D = "#519fdf"; # "#61afef"; # blue
      base0E = "#b668cd"; # "#c678dd"; # purple
      base0F = "#be5046"; # "#be5046"; # ?
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    pkgs.hyprpaper

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    pkgs.nerdfonts

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';

    ".config/hypr".source = ./hypr;
    ".config/waybar".source = ./waybar;
    ".config/helix".source = ./helix;
    ".config/alacritty.yml".source = ./alacritty.yml;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nertsal/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    SHELL = "fish";
    EDITOR = "hx";
  };

  # `git` config
  programs.git = {
    enable = true;
    userName = "nertsal";
    userEmail = "sasha.kudasov04@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # TODO maybe enable? idk what it does really
  # Nicely reload system units when changing configs
  # systemd.user.startServices = "sd-switch";

  # Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "fish";
      window.opacity = 0.9;
      colors = {
        primary = {
          background = "#${config.colorScheme.colors.base00}";
          foreground = "#${config.colorScheme.colors.base05}";
        };
        normal = {
          black = "${mainColors.black}";
          red = "${mainColors.red}";
          green = "${mainColors.green}";
          yellow = "${mainColors.yellow}";
          blue = "${mainColors.blue}";
          magenta = "${mainColors.purple}";
          cyan = "${mainColors.cyan}";
          white = "${mainColors.white}";
        };
      };
    };
  };

  # Notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "FiraCode Nerd Font 12";
        monitor = 1; # display on eDP-1
        alignment = "left";
        browser = "firefox";
        corner_radius = 5;
        layer = "top"; # to appear under fullscreen apps
        transparency = 30;
        offset = "10x20";
        frame_color = "#c0caf5";
      };
      urgency_low = {
        background = "${mainColors.black}";
        foreground = "#635d5c";
      };
      urgency_normal = {
        background = "${mainColors.black}";
        foreground = "#c0caf5";
      };
      urgency_critical = {
        background = "${mainColors.black}";
        foreground = "#de3c4b";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
