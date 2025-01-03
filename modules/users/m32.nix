{ ... }: {
  users.users.m32 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH22QmcssweQDZGpI55xzQHkOaUR05S4qIzt9ZomMJ+k m32@m32.io"
    ];
  };
}
