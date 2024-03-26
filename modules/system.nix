{ lib, self, config, ... }: {
  # Store commit data in generation label
  system.nixos.label =
    lib.mkIf (self ? rev)
    "${self.shortRev}-${lib.concatStringsSep "-" ((lib.sort (x: y: x < y) config.system.nixos.tags))}";

  # Also store commit revision where it can be accessed with `nixos-version`
  system.configurationRevision = self.rev or "dirty";

  # And finally, link the latest version of the subscribed flake to /etc/nixos, so it can be built from.
  # this is a pure flake option similar to that of system.copySystemConfiguration, but for another purpose
  environment.etc = {
    "nixos" = {
      source = "${self.sourceInfo.outPath}/**";
    };
  };
}
