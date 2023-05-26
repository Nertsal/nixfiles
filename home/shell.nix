{ config, pkgs, ... }:

{
  # Fish
  # programs.dircolors.enableFishIntegration = true;
  programs.starship.enableFishIntegration = true;
  programs.zoxide.enableFishIntegration = true;
  programs.zellij.enableFishIntegration = false;
  programs.fish = {
    enable = true;
    loginShellInit = ''
      cd ~/data
    '';
    shellInit = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      set fish_greeting '''
      any-nix-shell fish --info-right | source
    '';
    functions = {
      update_hm_env = ''
        set -e __HM_SESS_VARS_SOURCES
        set --prepend fish_function_path ${
          if pkgs ? fishPlugins && pkgs.fishPlugins ? foreign-env then
            "${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d"
          else
            "${pkgs.fish-foreign-env}/share/fish-foreign-env/functions"
        }
        fenv source ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh > /dev/null
        set -e fish_function_path[1]
      '';
      haskell_env = ''
        nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])"
      '';
    };
    shellAliases = {
      # Shortcuts for `exa`
      l  = "exa --icons -la";
      ls = "exa --icons -1a";
      lt = "exa --icons --tree";
      # No vim, only neovim
      vim = "nvim";
      # Always interactive `mv`
      mv = "mv -i";
      # Rebuild dotfiles
      dots = "home-manager --flake $HOME/nixfiles";
      # Rebuild flake
      nixos = "sudo nixos-rebuild --flake $HOME/nixfiles";
    };
  };

  # Bash
  # programs.dircolors.enableBashIntegration = true;
  programs.starship.enableBashIntegration = true;
  programs.zoxide.enableBashIntegration = true;
  programs.zellij.enableBashIntegration = false;
  programs.bash = {
    enable = true;
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
    shellAliases = config.programs.fish.shellAliases;
  };

  # Zellij - the superiour terminal multiplexer
  programs.zellij.enable = true;
  programs.zellij.settings = {
    simplified_ui = true;
    default_layout = "compact";
    default_mode = "normal";
    copy_on_select = false;
    copy_command = "wl-copy";
    ui.pane_frames = {
      rounded_corners = true;
      hide_session_name = true;
    };
  };

  # Zoxide - `cd` with memory
  programs.zoxide.enable = true;

  # Starship
  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = true;
    format = "$time$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$jobs$cmd_duration\n$directory$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = " [BASH](bright-white) ";
      zsh_indicator = " [ZSH](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = " ";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = " on [$symbol$branch]($style) ";
      symbol = "";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    time = {
      disabled = false;
      format = "[$time]($style)";
      style = "bold yellow";
    };
    cmd_duration = {
      format = " took [$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };

  # Dir colors
  # programs.dircolors.enable = true;
  # programs.dircolors.extraConfig = ''
  #   TERM alacritty
  # '';
}
