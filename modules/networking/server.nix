{ lib, ... }: {
  networking.domain = lib.mkDefault "cubit.sh";
}
