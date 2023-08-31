inputs@{ self, flake-utils, ... }:
let
  hardwarePath    = ./hardware;
  homeProfilePath = ./home;
  hostsPath       = ./hosts;
  systemPath      = ./system;
in flake-utils.lib.meld inputs [ hardwarePath homeProfilePath hostsPath systemPath ]
