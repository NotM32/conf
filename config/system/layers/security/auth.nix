{ ... }:
{
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth  = true;
  };

  security.pam.yubico = {
    # Commands for onboarding with the chalresp key in the second slot:
    # ykman otp chalresp --touch --generate 2
    # ykpamcfg -2 -v
    enable = true;
    debug  = false;
    mode   = "challenge-response";
  };
}
