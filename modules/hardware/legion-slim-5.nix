{ config, lib, modulesPath, self, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  environment.systemPackages = [ self.inputs.l5p-keyboard-rgb.packages.x86_64-linux.default ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
  boot.kernelModules = [ "kvm-amd" "nct6775" ];

  # boot.initrd.secrets =
  #   { "/persist/secrets/boot/pubkey.asc" =
  #       ../../home/gpg/pubkey.asc;
  #     "/persist/secrets/boot/cryptkey.gpg" =
  #       /persist/secrets/boot/cryptkey.gpg;
  #   };

  # Support for YubiKey PBA (two factor decryption)
  boot.initrd.luks.yubikeySupport = false;
  # Support for GPG smartcard decryption
  boot.initrd.luks.gpgSupport = true;
  # Support for FIDO2 decryption
  boot.initrd.luks.fido2Support = false;

  # Necessary (and a default) for multiple drives
  boot.initrd.luks.reusePassphrases = true;

  boot.initrd.luks.devices = {
    # fido2: yes
    # gpg: yes
    # yk: no
    "ucrypt" = {
      device = "/dev/nvme0n1p2";
      # PBA (haven't added key yet)
      # yubikey = {
      #   slot = 2;
      #   twoFactor = true;
      #   storage = {
      #     device = "$EFI_PART";
      #   };
      # };

      # gpg-card CCID smartcard support
      # gpgCard = {
      #   publicKey     = ../../home/gpg/pubkey.asc;
      #   encryptedPass = /persist/secrets/boot/cryptkey.gpg;
      # };

      # # FIDO2 support
      # fido2 = {
      #   credential = "6f80d6063d2301878832f87c28a51fe5";
      #   passwordLess = false;
      # };

      fallbackToPassword = true;
    };
  };


  fileSystems."/" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@home,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@nix,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/persist" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@persist,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/srv" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@srv,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/var" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@var,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@var/log,compress=zstd,noatime,autodefrag" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

  fileSystems."/swap" =
    { device = "/dev/mapper/ucrypt";
      fsType = "btrfs";
      options = [ "subvol=@swap" ];
      neededForBoot = true;
    };

  swapDevices = [
    { device = "/swap/swapfile"; }
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/6ac3d6fb-a96e-4b38-8a92-99918d3d266b";
  boot.kernelParams = [ "resume_offset=56141094" "nvidia-drm.modeset=1" ];
  systemd.sleep.extraConfig = ''
                               [Sleep]
                               HibernateMode=shutdown
                              '';

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  hardware.bluetooth.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Video Drivers / Hardware options
  allowUnfreePackages = [ "nvidia-x11" "nvidia-settings" ];

  services.xserver.videoDrivers = [ "nvidia" "modesetting" "fbdev" ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.nvidia = {
    modesetting.enable = false;
    open = false;
    nvidiaSettings = true;
  };

  # RGB Lighting Service
  systemd.services.legion-keyboard-rgb = {
    description = "Set Legion Keyboard RGB";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    before = [ "display-manager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        "${self.inputs.l5p-keyboard-rgb.packages.x86_64-linux.default}/bin/legion-kb-rgb set -c 32,32,32,32,32,32,32,32,32,32,32,32 --effect Static -b Low";
      Restart = "no";
    };
  };

}
