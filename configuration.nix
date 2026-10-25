# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.zsh.enable = true;
  users.users.swan.shell = pkgs.zsh;
  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;

  #VirtualMachineManager
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = ["virbr0"];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.flatpak.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  #hardware.nvidia.open = true;
  #hardware.nvidia.modesetting.enable = true;
  #hardware.graphics.enable = true;
  #hardware.graphics.enable32Bit = true;
  #hardware.graphics.extraPackages = with pkgs; [ vulkan-loader vulkan-tools ];
  #hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ vulkan-loader ];

  services.xserver.enable = true;
  #services.xserver = {
  #  enable = true;
  #  videoDrivers = [ "nvidia" ];
  #  };

  # environment.variables = {
  #  NVIDIA_VAAPI_DRIVER_CAPABILITIES = "decode,encode";
  #  GLX_VENDER_LIBRARY_NAME = "nvidia";
  #  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #  console = {
  #    font = "Lat2-Terminus16";
  #    keyMap = "us";
  #    useXkbConfig = true; # use xkb.options in tty.
  #  };

  # Enable the X11 windowing system.

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.swan = {
    isNormalUser = true;
    extraGroups = ["wheel" "kvm" "libvirtd" "docker"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # dnsmasq
    # docker
    #     cudatoolkit
    #     davinci-resolve
    # steam
    # prismlauncher
    # obs-studio
    # gamescope
    # lua-language-server
    # intelephense
    # typescript-language-server
    # zls
    nil
    # rust-analyzer
    # clang-tools
    # c3-lsp
    # serve-d
    # haskell-language-server
    # gopls
    # templ
    # alejandra
    haskellPackages.fourmolu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
