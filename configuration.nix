# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "lounge.kiosk.shack"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim
    rxvt_unicode.terminfo
    tmux
    htop
    pciutils
    usbutils
    killall
    sl
    glxinfo
    gcc # libstdc++.so.6
    gcc-unwrapped
    glibc
    patchelf
    evtest

    # touch driver 
    xorg.libXrandr
    xorg.libX11
    alsaLib

    # dependencies for kiosk
    chromium
    xdotool

    # dependencies for btclock-set and btclock-api
    bluez
    bluez-tools
    nodejs-10_x
    python
  ];

  # Important
  programs.nano.syntaxHighlight = true;

  powerManagement.enable = false; # we don't need power management here

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # currently the hostname lounge.kiosk.shack is unknown to the dns server
  services.avahi.hostName = "kiosk";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "@reboot	root	/home/shack/btclock-set/BtClock-Set.sh 3212"
    ];
  };

  systemd.services.btclockapi_readonly = {
    description = "BtClock node api port 80 - readonly";
    serviceConfig = {
	Type="simple";
	User="root";
	Group="root";
	Environment="NODE_ENV=production";
	WorkingDirectory="/home/shack/btclock-api";
	ExecStart="${pkgs.nodejs-10_x}/bin/node server.js --port 80 --readonly";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.btclockapi_readonly.enable = true;

  systemd.services.btclockapi_localhost = {
    description = "BtClock node api localhost port 8080";
    serviceConfig = {
	Type="simple";
	User="root";
	Group="root";
	Environment="NODE_ENV=production";
	WorkingDirectory="/home/shack/btclock-api";
	ExecStart="${pkgs.nodejs-10_x}/bin/node server.js --host localhost --port 8080";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.btclockapi_localhost.enable = true;

  systemd.services.gtouchd = {
    description = "eGalax Touch Daemon";
    serviceConfig = {
	Type="forking";
	User="root";
	Group="root";
	ExecStart="/home/shack/touch-driver/eGTouchD start";
	ExecReload="/home/shack/touch-driver/eGTouchD restart";
	ExecStop="/home/shack/touch-driver/eGTouchD stop";
    };
    unitConfig = {
	SourcePath="/home/shack/eGTouch_v2.5.6722.L-x/eGTouch64/eGTouch64withX/eGTouchD";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.gtouchd.enable = true;

  services.xserver.displayManager.lightdm = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "shack";
  };

  services.xserver.resolutions = [ { x = 1280; y = 1024; }  ]; 
  services.xserver.windowManager.default = "i3";
  services.xserver.desktopManager.default = "none";
  services.xserver.windowManager.i3.enable = true;

  services.xserver.inputClassSections = [
''
	Identifier "eGalax touch class"
	MatchProduct "eGalax Inc.|Touchkit|eGalax_eMPIA Technology Inc."
	MatchDevicePath "/dev/input/event*"
	Driver "evdev"
	# Option "Ignore"
''
''
	Identifier "eGalax mouse class"
	MatchProduct "eGalax Inc.|Touchkit|eGalax_eMPIA Technology Inc.|eGalaxTouch Virtual Device"
	MatchDevicePath "/dev/input/mouse*"
	Driver "void"
	Option "Ignore"
''
''
	Identifier "eGalax joystick class"
	MatchProduct "eGalax Inc.|Touchkit|eGalaxTouch Virtual Device"
	MatchDevicePath "/dev/input/js*"
	Driver "void"
	Option "Ignore"
''
''
	Identifier "eGalax virtual class"
	MatchProduct "eGalaxTouch Virtual Device"
	MatchDevicePath "/dev/input/event*"
	Driver "evdev"
	Option  "Calibration"   "1682 256 293 1671"
	Option  "SwapAxes"  "1"
	''
	''
		Identifier  "calibration"
		MatchProduct    "eGalax Inc. Touch"
		Option  "Calibration"   "1682 256 293 1671"
		Option  "SwapAxes"  "1"
	''
	];

  environment.etc ={
    "eGTouchL.ini" = {
      source = "/home/shack/touch-driver/eGTouchL.ini";
      mode = "0666";
    };
  };

  hardware.opengl.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shack = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}

