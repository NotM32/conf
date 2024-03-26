{ pkgs, ... }: {
  # Use the latest version of nix
  nix.package = pkgs.nixUnstable;

  nix.settings = {
    system-features = [ "recursive-nix" "kvm" "nixos-test" "big-parallel" ];
    experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
    trusted-users = [ "root" "m32" ];
  };

  nix.gc = {
    automatic = true;
    dates = "08:00";
    options = "--delete-older-than 7d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
}
