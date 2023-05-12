m32's system and configs
------------------------

Just some configs. Some tidbits below

## Systems

| hostname    | system role | specs CPU/RAM/Motherboard                                                                                                                                                     | use case                  |
|-------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|
| phoenix     | workstation | 32C/16T@4.00GHz AMD Ryzen 9 5950x, 32G DDR4@3600MHz, Asus ROG Crosshair VIII Impact Mini-DTX, GTX 1070                                                                        | primary                   |
| momentum    | laptop      | ThinkPad T430, 2K display mod, onboard hardware RNG, onboard TPM2.0, CoreBoot TianoCore payload UEFI with secure boot, 16G Memory (not an Optimus mobo, but I would like one) | secure mobile workstation |
| maple       | server      | OVH VPS                                                                                                                                                                       | low cost remote computer  |
| antikythera | laptop      | idk, it was an "i need a computer" purchase                                                                                                                                   | mobile gamin              |


## Provisioning a System

Install NixOS. Use the flake URI as the system's configuration flake.

## The `util` Thing

The `util` folder holds a very simple set of functions. Their purpose is
almost entirely to serve my syntax preference. I tend to configure things
one way. Categorization of these config snippets based on different their
different functionalities means that under the right setup, things should
be easy to compose.

The `util` functions enables that composition to be short, sweet and reusable.

### The directory layout

The `util` thing doesn't care about directory layout, but the function args
make the most sense with the current directory layout.

I break things down into 3 spots.

 * `machines`
   Holds the hardware configurations for a specific host, or flavor of host.
   Things like disk layout, special pieces of hardware, etc.
 * `system`
   This one is for all the userland services, global desktop stuff. Things that
   aren't per-user, or don't need to be.

   Files in the root of this one are for different system configurations. I use
   `default.nix` as barebones basics for the other ones, but it could be all in
   that one file also.

 * `config`
   This is basically all the dotfiles, and home manager configuration. The
   subdirectories are used for individual configuration files, rather than
   nix files. All files at the root should be nix user configurations or
   something of the like.

   Different files here could belong to a different 'theme' of the same user.
   If I ever end up themeing, I'll prolly just prefix the files.

### Adding a Host

- todo -

### Composing the host
