{ config, pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  # For nvidia to work on wayland
  extraEnv = {
    WLR_NO_HARDWARE_CURSORS = "1";
    # LIBVA_DRIVER_NAME = "nvidia";
    # XDG_SESSION_TYPE = "wayland";
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
in
{
  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfree = true;

  # NVIDIA environment variables
  environment.variables = extraEnv;
  environment.sessionVariables = extraEnv;

  environment.systemPackages = with pkgs; [
    nvidia-offload # NVIDIA offload command
    glxinfo # OpenGL info
    glmark2 # OpenGL benchmark
  ];

  # Enable OpenGL
  hardware.opengl.enable = true;

  # Select the appropriate driver version for the GPU
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  # nvidia-drm.modeset=1 is required for wayland
  hardware.nvidia.modesetting.enable = true;

  # Fix graphical corruption on suspend/resume
  # hardware.nvidia.powerManagement.enable = true;
  # hardware.nvidia.powerManagement.finegrained = true; # TODO: check

  # Optimus mode
  hardware.nvidia.prime = {
    sync.enable = true; # gpu always
    # reverseSync.enable = true; # mainly Intel, nvidia if necessary
    # offload.enable = true; # gpu on demand
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  # Fix black screen on sync
  # Note: disables my laptop monitor
  # boot.kernelParams = [ "module_blacklist=i915" ];

  # setting is also valid for wayland installations despite it's name
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.wayland = true;
  };

  # Kernel modules
  # <https://wiki.hyprland.org/Nvidia/>
  # TODO: figure out how to make them work, or maybe they are not needed
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   nvidia nvidia_modeset nvidia_uvm nvidia_drm
  # ];

  # required for external monitor usage on offload
  # specialisation = {
  #   external-display.configuration = {
  #     system.nixos.tags = [ "external-display" ];
  #     hardware.nvidia.prime.offload.enable = lib.mkForce false;
  #     hardware.nvidia.powerManagement.enable = lib.mkForce false;
  #   };
  # };

  # Fix screen tearing: might reduce performance for OpenGL and WebGL
  # Note: idk if it works
  # hardware.nvidia.forceFullCompositionPipeline = true;
}
