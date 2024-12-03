{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    tamzen
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.geist-mono
  ];
}
