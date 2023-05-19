{ config, pkgs, ... }:

{
  # Fish
  # programs.dircolors.enableFishIntegration = true;
  programs.starship.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    loginShellInit = ''
      cd ~/data
    '';
    shellInit = ''
      set fish_greeting '''
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
    };
    shellAliases = {
      # Shortcuts for `lsd`
      l = "lsd -lA";
      ls = "lsd -1A";
      lt = "lsd --tree";
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
  programs.bash.enable = true;
  # programs.dircolors.enableBashIntegration = true;
  programs.starship.enableBashIntegration = true;
  programs.bash.shellAliases = config.programs.fish.shellAliases;

  # Zsh
  programs.zsh.enable = false;
  # programs.dircolors.enableZshIntegration = true;
  programs.starship.enableZshIntegration = false;
  programs.zsh.shellAliases = config.programs.fish.shellAliases;
  programs.zsh.enableAutosuggestions = true;

  # Starship
  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
      zsh_indicator = "[ZSH](bright-white) ";
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
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
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
    cmd_duration = {
      format = "[$duration]($style) ";
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
