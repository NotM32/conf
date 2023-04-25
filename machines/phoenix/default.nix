{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.secrets =
    { "/persist/secrets/boot/pubkey.asc" =
        /persist/secrets/boot/pubkey.asc;
      "/persist/secrets/boot/cryptkey.gpg" =
        /persist/secrets/boot/cryptkey.gpg;
    };

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
    "uroot" = {
      device = "/dev/disk/by-uuid/e245dbf3-1c20-4a16-8ac1-d45582a2abee";
      preLVM = true;
      # PBA (haven't added key yet)
      # yubikey = {
      #   slot = 2;
      #   twoFactor = true;
      #   storage = {
      #     device = "$EFI_PART";
      #   };
      # };

      # gpg-card CCID smartcard support
      gpgCard = {
        publicKey     = /persist/secrets/boot/pubkey.asc;
        encryptedPass = /persist/secrets/boot/cryptkey.gpg;
      };

      # FIDO2 support
      fido2 = {
        credential = "6f80d6063d2301878832f87c28a51fe5";
        passwordLess = false;
      };

      fallbackToPassword = true;
    };

    # fido2: no
    # gpg: yes
    # yk: no
    "uroot2" = {
      device = "/dev/disk/by-uuid/53243a77-1b78-49c3-8d26-ccb118c5a692";
      preLVM = true;

      gpgCard = {
        publicKey     = /persist/secrets/boot/pubkey.asc;
        encryptedPass = /persist/secrets/boot/cryptkey.gpg;
      };

      fallbackToPassword = true;
    };
  };


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@home,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@nix,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@persist,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/srv" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@srv,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@var,compress=zstd,noatime,autodefrag" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/51718d2c-a082-4ad4-9836-c0ecffeb4eee";
      fsType = "btrfs";
      options = [ "subvol=@var/log,compress=zstd,noatime,autodefrag" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C900-11F4";
      fsType = "vfat";
    };

  swapDevices = [
    { device = "/dev/disk/by-uuid/9e60cced-d0fc-4fc9-9093-421dfcadf101"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0f3u3u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  hardware.bluetooth.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
