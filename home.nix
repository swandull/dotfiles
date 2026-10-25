{
  config,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  home.username = "swan";
  home.homeDirectory = "/home/swan";

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  xdg.enable = true;

  services.flatpak = {
    enable = true;

    # FIX: Points to the actual data repository backend instead of the website
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org";
      }
    ];

    # List your desired applications here
    packages = [
      "org.vinegarhq.Sober"
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/swan/dotfiles/nvim/";
    recursive = true;
  };

  #xdg.configFile."alacritty" = {
  #       source = config.lib.file.mkOutOfStoreSymlink "/home/swan/dotfiles/alacritty/";
  #    recursive = true;
  #    };

  home.packages = with pkgs; [
    ripgrep
    wget
    # vlc
    # gimp
    # btop
    # tealdeer
    git
    # vesktop
    alacritty
    neovim
    fastfetch
    pavucontrol
    # qbittorrent
    # vscode
  ];

  # programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "jispwoso";
      plugins = [
        "git"
      ];
    };
  };

  programs.git.enable = true;

  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };

  home.stateVersion = "26.05";
}
