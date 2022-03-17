# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./unstable.nix
    ];


  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only

  networking.hostName = "hawking"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Enables network manager
  networking.dhcpcd.wait = "if-carrier-up";
  networking.extraHosts = 
''
	127.0.0.1 local.localhost
'';

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;
  networking.interfaces.wwp0s20f0u9.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
	  font = "Lat2-Terminus16";
	  keyMap = "no";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkbOptions = "caps:escape";
    layout = "no";
  
    displayManager = {
        gdm.enable = true;
        defaultSession = "none+awesome";
    };

    desktopManager = {
      gnome = {
        enable = true;
      };
    };

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];

    };
  };

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  virtualisation.docker.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ptrkrlsrd = {
	  isNormalUser = true;
          shell = pkgs.zsh;
	  extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    arkade
    cargo
    docker
    dotnet-runtime
    dotnet-sdk
    faas-cli
    file
    firefox
    fzf
    gcc
    gdb
    git
    home-manager
    htop
    jq
    kind
    kube3d
    kubectl
    kubernetes-helm
    lua
    minikube
    nodejs
    nushell
    openconnect
    openvpn
    picom
    protobuf
    ripgrep
    rnix-lsp
    stow
    terraform
    tmux
    unzip
    vim_configurable
    wget
    xclip
    xorg.xbacklight
    xsecurelock
    zoxide
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
	  mtr.enable = true;
	  gnupg.agent = {
		  enable = true;
		  enableSSHSupport = true;
	  };

	  zsh = {
		  shellAliases = {
			  k = "kubectl";
			  l = "ls -alh";
			  ll = "ls -l";
			  ls = "ls --color=tty";
			  nv = "nvim";
			  tf = "terraform";
		  };
	  };

	  neovim = {
		  enable = true;
		  vimAlias = true;
		  viAlias = true;
		  package = pkgs.neovim-nightly;
	  };
  };

  environment.interactiveShellInit = ''

    export EDITOR=$(which nvim)
  '';

  # List services that you want to enable:
  services = {
    openssh.enable = true;

    autorandr.enable = true;

    dbus.enable = true;

    picom = {
	    enable = true;
	    vSync = true;
	    backend = "glx";
	 };

	 redis.enable = false;
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      enable = true;
      antialias = true;
      useEmbeddedBitmaps = true;

      defaultFonts = {
        serif = ["Source Serif Pro" "DejaVu Serif"];
      };

    };

    fonts = with pkgs; [
      fira
      fira-code
      fira-mono
      hasklig
      nerdfonts
      overpass
      source-code-pro
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "21.11"; # Don't change this
}

