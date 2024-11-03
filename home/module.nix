{ config, lib, ... }:

with lib;

let
  cfg = config.customize;
in {
  options.customize = {
    enable = mkEnableOption "customize home manager module";

    fontName = mkOption {
      default = "terminus";
      type = types.str;
      description = "Font to use across applications";
    };
  };

  config = {

  };
}
