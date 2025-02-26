{ lib, config, ... }:
with lib;
let
  cfg = config.disks.single;

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

  size = cfg.size
    + (if cfg.enableSwap then cfg.swapSize else 0);

  content = {
    type = "btrfs";
    subvolumes = {
      "/@" = mkIf (cfg.rootState == "persistent") {
        mountpoint = "/";
        mountOptions = [ "compress=zstd" "noatime" "noexec" ];
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
        mountOptions = [ "compress=zstd" "noatime" "noexec" ];
      };
      "/@var" = {
        mountpoint = "/var";
        mountOptions = [ "compress=zstd" "noatime" "noexec" ];
      };
      "/@var/log" = {
        mountpoint = "/var/log";
        mountOptions = [ "compress=zstd" "noatime" "noexec" ];
      };
      "@swap" = mkIf cfg.enableSwap {
        mountpoint = "/.swapvol";
        swap.swapfile.size = "${toString cfg.system.swapSize}G";
      };
      "/@srv" = {
        mountpoint = "/srv";
        mountOptions = [ "compress=zstd" "noatime" "noexec" ];
      };
    };
  };

in {
  imports = [
    ./remote-decrypt.nix
    ../ephemeral/persist.nix
  ];

  options.disks.single = {
    encrypt = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable encryption of all disks data";
    };
    rootState = mkOption {
      type = types.enum [ "ephemeral" "persistent" ];
      default = "persistent";
      example = "ephemeral";
      description =
        "Choose ephemeral or persistent nature of the system data";
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

  config = {
    disko.devices = {
      disk = attrsets.genAttrs (cfg.disks) (device:
        let
          deviceName = (getDeviceName device);
        in {
          type = "disk";
          name = deviceName;
          inherit device;
          content = {
            type = "gpt";
            partitions = {
              # EFI system partition if disk is allocated to contain system data
              "${deviceName}_EFIBOOT" =
                mkIf (device == builtins.head cfg.disks) {
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
                mkIf (builtins.elem device cfg.disks && cfg.encrypt) {
                  label = "${deviceName}_systemCrypt";
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "${deviceName}_system";
                    settings = { allowDiscards = true; };
                    passwordFile = "/tmp/crypt.key";
                    content = mkIf (device == lists.last cfg.disks) {
                      type = "btrfs";
                      extraArgs = mkExtraArgs {
                        dataSet = "system";
                        inherit device;
                      };
                      inherit (content) subvolumes;
                    };
                  };
                };
              # Unencrypted system partition
              "${deviceName}_system" =
                mkIf (builtins.elem device cfg.disks && !cfg.encrypt) {
                  label = "${deviceName}_system";
                  size = "100%";
                  content = mkIf (device == lists.last cfg.disks) {
                    type = "btrfs";
                    extraArgs = mkExtraArgs {
                      dataSet = "system";
                      inherit device;
                    };
                    inherit (content) subvolumes;
                  };
                };
            };
          };
        });
      nodev."/" = mkIf (cfg.state == "ephemeral") {
        fsType = "tmpfs";
        mountOptions = [ "defaults" "size=25%" "mode=755" ];
      };
    };

    fileSystems."/" = mkIf (cfg.state == "ephemeral") {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=25%" "mode=755" ];
    };

    ephemeral.enable = cfg.state == "ephemeral";
  };
}
