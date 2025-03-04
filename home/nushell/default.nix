{ pkgs, lib, ... }:
let
  # Needs to be updated
  nu-plugin-dialog = with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "nushell_plugin_dialog";
      version = "0.1.0";

      src = fetchFromGitHub {
        owner = "Trivernis";
        repo = "nu-plugin-dialog";
        rev = "v0.1.0";
        hash = "sha256-hRS0HgLyEFKOtD04ex3N6k818705/KHbI4wpPJiBdKw=";
      };
      cargoHash = "sha256-353ftE4O7ZG6IrE7FOeHVZjdK0aDqR8hqm2wN3XK0ko=";

      nativeBuildInputs = [ pkg-config ]
        ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
      cargoBuildFlags = [ "--package nu_plugin_dialog" ];

      passthru.updateScript = nix-update-script { };

      meta = {
        description = "A nushell plguin for user interaction.";
        mainProgram = "nu_plugin_dialog";
        homepage = "https://github.com/Trivernis/nu-plugin-dialog";
      };
    };
in {
  home.packages = [ pkgs.nufmt ];

  programs.nushell = {
    enable = true;

    plugins = (with pkgs.nushellPlugins; [
      formats
      gstat
      polars
      query
      # dbus
      # units
    ]);
  };

  # * Additional shell utils
  programs.broot = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv.enableNushellIntegration = true;
  programs.keychain.enableNushellIntegration = true;
}
