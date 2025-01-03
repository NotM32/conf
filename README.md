# conf
Configuration for my computers. You may install this on your computer also, and experience your computer as if it ran identical software to my computer. 

Everything runs NixOS. Dotfiles are setup for function. I just need a tiling window manager, emacs, firefox, and a terminal emulator. I like some color consistency among them; generally, there is no extravagant theming beyond that.

## System Specs

It seems like people like to show this off when they have 

| hostname        | system role | specs CPU/RAM/Motherboard                                                                     | use case                      |
|-----------------|-------------|-----------------------------------------------------------------------------------------------|-------------------------------|
| phoenix         | workstation | Ryzen 5950x, 32G DDR4, GTX 4070                                                               | primary desktop               |
| nova            | laptop      | 8C/16T@4GHz AMD Ryzen 7435HS, GTK 3070M, 32G DDR4                                             | primary laptop                |
| momentum        | laptop      | ThinkPad T430, 2K WQHD display, onboard RNG, TPM2.0, CoreBoot UEFI w/ secure boot. 16G Memory | secure mobile laptop          |
| maple           | server      | VPS                                                                                           | low cost remote computer      |
| ~~antikythera~~ | ~~laptop~~  | ~~4C/8T@1.9-4.9GHz Intel i7-10510U, GTX 1050M, 16G RAM, 1000G/32G Storage/Optane cache~~      | ~~secondary travel computer~~ |

## Security

On machines that support it, I have secureboot enabled through the [Lanzaboote](https://github.com/nix-community/lanzaboote/) project. On Machines that didn't support it originally, I have made them support it.

All disks are fully encrypted. You can see the disko config in this repo. While the disko layout has been tested, most disks were manually commissioned. Some steps to make things more secure are not documented in this repo, including extending the iter time and some similar stuff.

I make heavy use of yubikeys. I sign all my commits with a PGP subkey only available from the yubikey. 

I've added hardware modifications to most machines that are security oriented. This includes hardware random number generates, removal of hardware requiring binary blobs and similar.

Secrets are managed with sops-nix. The yubikey is involved in this process. I have some documentation in the `docs/` folder I've written. This is under construction.

## Deployment

Most machines have been deployed with nixos-anywhere. Some were installed with custom generated ISO images. I am no longer using this workflow. For my business, I have built a netboot derivation that helps to quickly install hosts. This is great if you have a lot of hosts to install. I may make those configuration modules available here in the future. Keep an eye out for an article about this workflow on [my website](https://m32.io)

In general, I build the system closures locally when hacking on this config. That means working with the `nixos-rebuild` development loop. Some features I test with the `nixos-rebuild build-vm` functionality. 

I deploy updates remotely with `nixos-rebuild --remote-host`. All my machines have an overlay network and can reach eachother on a shared subnet, as if they were local, across the internet. 

## Roadmap/TODO
- [ ] Build coreboot and tianocore payload with Nix for T430 
      See: [ownerboot](https://codeberg.org/amjoseph/ownerboot/)
- [ ] Validation of PGP signatures during auto update
- [ ] Build caching among machines

Above is not inclusive; my development cycles on this repository, alongside my interests and focuspoints will outpace me updating this todo list.

### Note

This repository is a filtered mirror/fork of what I actually use. I've excluded some configuration modules related to security specifics, configurations for isolated applications and production configuration for secure endpoints. 

Things are continually improving; for one reason or another, I feel incredibly bandwidth limited by a keyboard. I yearn for libre neurological human I/O technology. This handicap results in a long idea-code iteration unfortunately.

## See also
This repository borrows from the formats and styles of some of these. I've also used these repositories to pickup NixOS over the years.

- [serokell/gemini-infra](https://github.com/serokell/gemini-infra) - Shows the excellent synergy between Terraform and NixOS
- [TUM-DSE/doctor-cluster-config](https://github.com/TUM-DSE/doctor-cluster-config/tree/master) - Also shows how TF can compliment NixOS, this is a thoroughly configured cluster
- [deuxfleurs/infrastructure](https://git.deuxfleurs.fr/Deuxfleurs/infrastructure) - Some interesting methods here
- [vfifino/nix-geht](https://github.com/vifino/nix-geht) - Very intricate module implementation, great to learn from
- [MicroVM.nix](https://github.com/astro/microvm.nix) - Great tool to use, good example of what a library flake should like
- [niki-on-github/nixos-k3s](https://github.com/niki-on-github/nixos-k3s) - Great example of using k3s with NixOS and keeping a gitops flow
- [serokell/serokell.nix](https://github.com/serokell/serokell.nix) - Serokell is great
- [Janik-Haag/nixbox](https://github.com/Janik-Haag/nixbox) - Was impressed with the thought process of this library
- [amjoseph/ownerboot](https://codeberg.org/amjoseph/ownerboot/) - this is great!
