{ lib, config, ... }:
with lib;
let
  cfg = config.disks;

  getDeviceName = device: "${lists.last (strings.splitString "/" device)}";
  # functio to generate the extraArgs for mkfs.btrfs when using raid
  mkExtraArgs = args:
    [ "-f" "-m dup" "-d ${cfg."${args.dataSet}".redundancyTarget}" ]
    ++ (if cfg.encrypt then
      (map (disk: "/dev/mapper/${getDeviceName disk}_${args.dataSet}")
        cfg."${args.dataSet}".disks)
    else
      (map (disk:
        (if (getDeviceName disk) != (getDeviceName args.device) then
          "/dev/disk/by-partlabel/${getDeviceName disk}_${args.dataSet}"
        else
          "")) cfg."${args.dataSet}".disks));

  system.size = cfg.system.size
    + (if cfg.system.enableSwap then cfg.system.swapSize else 0);
  system.content = {
    type = "btrfs";
    subvolumes = {
      "/@" = mkIf (cfg.system.state == "persistent") {
        mountpoint = "/";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
      "/@home" = {
        mountpoint = "/home";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
      "/@nix" = {
        mountpoint = "/nix";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
      "/@persist" = {
        mountpoint = "/persist";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
      "/@var" = {
        mountpoint = "/var";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
      "/@var/log" = {
        mountpoint = "/var/log";
        mountOptions = [ "compress=zstd" "noatime" "noexec" ];
      };
      "@swap" = mkIf cfg.system.enableSwap {
        mountpoint = "/.swapvol";
        swap.swapfile.size = "${toString cfg.system.swapSize}G";
      };
    };
  };

  data.content = {
    type = "btrfs";
    subvolumes = {
      "/@srv" = {
        mountpoint = "/srv";
        mountOptions = [ "compress=zstd" "noatime" ];
      };
    };
  };
in {
  imports = [
    ./remote-decrypt.nix
    ../ephemeral/persist.nix
  ];

  options.disks = {
    encrypt = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable encryption of all disks data";
    };
    system = {
      state = mkOption {
        type = types.enum [ "ephemeral" "persistent" ];
        default = "persistent";
        example = "ephemeral";
        description =
          "Choose ephemeral or persistent nature of the system data";
      };
      size = mkOption {
        description = "Size in GB to allocate to the system data";
        type = types.int;
        default = 25;
        example = 100;
      };
      disks = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "/dev/disk/by-diskseq/1" ];
        description = "Disks to assign for use by system data";
      };
      redundancyTarget = mkOption {
        type = types.enum [
          "none"
          "single"
          "dup"
          "raid0"
          "raid1"
          "raid1c3"
          "raid10"
        ];
        default = "raid0";
        example = "raid1";
        description = "Redundancy level for the system filesystem";
      };

      enableSwap = mkEnableOption "swap file ";
      swapSize = mkOption {
        description = "Size of swapfile, if enabled";
        type = types.int;
        default = 32;
        example = 0;
      };
    };

    data = {
      disks = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "/dev/disk/by-diskseq/2" ];
        description = "Disks to assign for use by data";
      };

      redundancyTarget = mkOption {
        type = types.enum [
          "none"
          "single"
          "dup"
          "raid0"
          "raid1"
          "raid1c3"
          "raid10"
        ];
        default = "single";
        example = "raid1";
        description = "Redundancy level for the system filesystem";
      };
    };
  };

  config = {
    disko.devices = {
      disk = attrsets.genAttrs (cfg.system.disks ++ cfg.data.disks) (device:
        let deviceName = (getDeviceName device);
        in {
          type = "disk";
          name = deviceName;
          inherit device;
          content = {
            type = "gpt";
            partitions = {
              # EFI system partition if disk is allocated to contain system data
              "${deviceName}_EFIBOOT" =
                mkIf (device == builtins.head cfg.system.disks) {
                  size = "512M";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "defaults" ];
                  };
                };
              # System encrypted partition if it is to be included
              "${deviceName}_systemCrypt" =
                mkIf (builtins.elem device cfg.system.disks && cfg.encrypt) {
                  label = "${deviceName}_systemCrypt";
                  size = "${toString system.size}G";
                  content = {
                    type = "luks";
                    name = "${deviceName}_system";
                    settings = { allowDiscards = true; };
                    passwordFile = "/tmp/crypt.key";
                    content = mkIf (device == lists.last cfg.system.disks) {
                      type = "btrfs";
                      extraArgs = mkExtraArgs {
                        dataSet = "system";
                        inherit device;
                      };
                      inherit (system.content) subvolumes;
                    };
                  };
                };
              # Unencrypted system partition
              "${deviceName}_system" =
                mkIf (builtins.elem device cfg.system.disks && !cfg.encrypt) {
                  label = "${deviceName}_system";
                  size = "${toString system.size}G";
                  content = mkIf (device == lists.last cfg.system.disks) {
                    type = "btrfs";
                    extraArgs = mkExtraArgs {
                      dataSet = "system";
                      inherit device;
                    };
                    inherit (system.content) subvolumes;
                  };
                };
              # Encrypted Data Partition
              "${deviceName}_dataCrypt" =
                mkIf (builtins.elem device cfg.data.disks && cfg.encrypt) {
                  label = "${deviceName}_dataCrypt";
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "${deviceName}_data";
                    settings = { allowDiscards = true; };
                    passwordFile = "/tmp/crypt.key";
                    content = mkIf (device == lists.last cfg.data.disks) {
                      type = "btrfs";
                      extraArgs = mkExtraArgs {
                        dataSet = "data";
                        inherit device;
                      };
                      inherit (data.content) subvolumes;
                    };
                  };
                };
              # Data Partition Unencrypted
              "${deviceName}_data" =
                mkIf (builtins.elem device cfg.data.disks && !cfg.encrypt) {
                  label = "${deviceName}_data";
                  size = "100%";
                  content = mkIf (device == lists.last cfg.data.disks) {
                    type = "btrfs";
                    extraArgs = mkExtraArgs {
                      dataSet = "data";
                      inherit device;
                    };
                    inherit (data.content) subvolumes;
                  };
                };
            };
          };
        });
      nodev."/" = mkIf (cfg.system.state == "ephemeral") {
        fsType = "tmpfs";
        mountOptions = [ "defaults" "size=25%" "mode=755" ];
      };
    };

    fileSystems."/" = mkIf (cfg.system.state == "ephemeral") {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=25%" "mode=755" ];
    };

    ephemeral.enable = cfg.system.state == "ephemeral";

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.gfxmodeEfi = "auto";
  };
}
