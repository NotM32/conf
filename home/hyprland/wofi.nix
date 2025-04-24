{ pkgs, ... }: {
  programs.wofi = {
    enable = true;

    settings = { gtk_dark = true; };

    style = ''
      * {
        font-family: 'Hack Nerd Font';
        font-size: 12px;
      }

      #window,
      #input,
      #inner-box,
      #expander-box {
        color: #E4E4E8;
        background-color: #181818;
        border: none;
        outline: none;
      }

      #entry {
        background-color: #181818;
      }

      #entry:selected {
        background-color: #91B9C7;
      }

      #input:active {
        border-color: #91B9C7;
      }
    '';
  };

  home.packages = with pkgs; [ wofi-power-menu ];
}
