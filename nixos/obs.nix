{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        input-overlay
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    })
  ];
}
