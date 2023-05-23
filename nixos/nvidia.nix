{ config, pkgs, lib, ... }:


let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export LIBVA_DRIVER_NAME=nvidia
    export XDG_SESSION_TYPE=wayland
    export GBM_BACKEND=nvidia-drm
    export WLR_NO_HARDWARE_CURSORS=1
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfree = true;

  # setting is also valid for wayland installations despite it's name
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # hardware.nvidia.package = pkgs.linuxKernel.packages.linux_6_1.nvidia_x11;
  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
  hardware.nvidia.modesetting.enable = true;

  # NVIDIA environment variable
  environment.systemPackages = [ nvidia-offload ];

  # Kernel modules
  # <https://wiki.hyprland.org/Nvidia/>
  # TODO: figure out how to make them work
  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   nvidia nvidia_modeset nvidia_uvm nvidia_drm
  # ];

  hardware.nvidia.prime = {
    sync.enable = true; # gpu always
    offload.enable = false; # gpu on demand
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  # Fix black screen
  # Note: also disables my laptop monitor, and hides cursor
  # boot.kernelParams = [ "module_blacklist=i915" ];

  # Fix screen tearing: might reduce performance for OpenGL and WebGL
  # Note: idk if it works
  hardware.nvidia.forceFullCompositionPipeline = true;

  # Fix graphical corruption on suspend/resume
  # TODO: check hardware.nvidia.powerManagement.finegrained
  # hardware.nvidia.powerManagement.enable = true;

  # # required for external monitor usage on nvidia offload
  # specialisation = {
  #   external-display.configuration = {
  #     system.nixos.tags = [ "external-display" ];
  #     hardware.nvidia.prime.offload.enable = lib.mkForce false;
  #     hardware.nvidia.powerManagement.enable = lib.mkForce false;
  #   };
  # };
}
