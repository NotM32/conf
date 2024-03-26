{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    unzip
    lm_sensors
    wireguard-tools
    cachix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "obsidian"
      "spotify"
      "pycharm-community"
      "terraform" # TODO: Use OpenTofu or migrate all HCL I've written to Pulumi
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # EOL, required for Obsidian
  ];
}
