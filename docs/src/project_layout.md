# Project Layout
In general, the concept of the hierarchy I've created is designed to encourage keeping a separation of duties at different system layers.

That is, to segregate the modules required by a certain, hardware configuration (physical configuration, shared among many host machines) from the roles that they perform.

A similar thought process applies to the home-manager configuration; since I am using this to maintain my own computers, the profiles can get quite heavy. Therefore, layers can be applied atop a base configuration for my user profile.

```ada
├── hardware
├── home
│   ├── emacs            // Use these folders for any non-nix config files
│   ├── gpg              // or your pgp pubkey
│   ├── mail
│   ├── modules          // `modules` is reserved for nix ocnfiguration layers
│   │   ├── base.nix     // `base.nix` is the only layer applied by default to the home-manager config
│   │   ├── custom1.nix  // Other modules are made available for use by their filename here
│   │   └── custom2.nix
│   ├── pam
│   ├── ssh
│   ├── default.nix
│   └── user.nix         // This is where the `users.users` implementation for the user should live
├── hosts
└── system
    ├── backup
    ├── disks
    ├── network
    └── default.nix
```
