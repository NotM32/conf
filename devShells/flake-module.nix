{ self, inputs, ... }:
{
  perSystem =
    {
      inputs',
      self',
      pkgs,
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          self.packages.${system}.docs

          pkgs.ipmitool
          inputs.nixos-anywhere.packages.${system}.nixos-anywhere-pxe
          pkgs.pixiecore
          pkgs.openssh
          pkgs.gitMinimal
          pkgs.rsync
          pkgs.coreutils
          pkgs.curl
          pkgs.gnugrep
          pkgs.findutils
          pkgs.gnused
          pkgs.sops
          pkgs.jq
          pkgs.nushell

          # terraform
          pkgs.opentofu

          # pam tools
          pkgs.pam_u2f
          pkgs.otpw
          pkgs.oath-toolkit
          pkgs.pamtester

          # secureboot
          pkgs.sbctl
        ] ++ pkgs.lib.optional (pkgs.stdenv.isLinux) pkgs.mkpasswd;

        shellHook = ''
            # nu -e 'use scripts/'
          "
        '';
      };
    };
}
