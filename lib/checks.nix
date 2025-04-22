{ self, inputs, ... }: {
  perSystem = { pkgs, self', ... }:
    let
      # Helper to get a list of non-free packages
      getNonFreePackages = pkgs: config:
        let
          # Get all packages from the configuration
          allPackages = config.environment.systemPackages;

          # Check if a package is non-free by examining its license
          isNonFree = pkg:
            pkg ? meta && pkg.meta ? license && (let
              license = pkg.meta.license;
              # Handle license as a single license or a list of licenses
              licenses =
                if builtins.isList license then license else [ license ];
              # A package is non-free if any of its licenses is non-free
            in pkgs.lib.any (l: l != null && (l ? free) && !l.free) licenses);

          # Filter non-free packages
          nonFreePackages = pkgs.lib.filter isNonFree allPackages;
        in nonFreePackages;

      # check to see if package is in firejail wrapped binaries
      hasFirejailConfig = pkg: config:
        let name = pkg.pname or pkg.name;
        in builtins.hasAttr name config.programs.firejail.wrappedBinaries;

      # check to see if firejail has a default profile for the package
      hasFirejailProfile = pkgs: pkg:
        let
          name = pkg.pname or pkg.name;
          firejailProfilePath = "${pkgs.firejail}/etc/firejail/${name}.profile";
        in builtins.pathExists firejailProfilePath;

      nonFreeWithoutFirejail = config:
        (pkgs.lib.filter (pkg: !(hasFirejailConfig pkg config))
          (getNonFreePackages pkgs config));

      allConfigs = f: nixosConfigurations:
        let
          result = builtins.map f (builtins.map (builtins.getAttr "config")
            (builtins.attrValues nixosConfigurations));
        in pkgs.lib.flatten result;
    in {
      checks = let
        checkFirejailNonfree = pkgs.runCommand "check-firejail-nonfree" { } ''
          touch $out

          ${pkgs.lib.concatMapStrings (pkg:
            let name = pkg.pname or pkg.name;
            in ''
              echo "WARNING: Non-free package '${name}' is installed but no firejail wrapped binary exists" | tee -a $out
            '') (nonFreeWithoutFirejail self.nixosConfigurations.nova.config)}

            if [ -s $out ]; then
               echo "Check failed due to non-free packages lacking firejail profiles";
               exit 0
            fi
        '';
      in { nonfreeHaveFirejail = checkFirejailNonfree; };
    };
}
