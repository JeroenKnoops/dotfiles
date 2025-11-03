# dotfiles

This are some of the dotfiles for my system


# Dotfiles

## `nvim`

This is the folder with my basic nvim setup

## Machines

### Omarchy

`sh101` - Thinkpad laptop

### MacOS

`MACHXPVL4MXK7` - MacOS

### NUC 

`mpc2000xl` - NUC1
`tb303` - NUC2

### Build machine


## Installation guide

### Omarchy

- Install Omarchy
- Configure 1password - login - ssh
- Clone this repository
- Install nix ( single user mode )
- Enable flakes ( `~/.config/nix/nix.conf` )
- Install home-manager ( with flakes )
  - `nix run home-manager/master -- init --switch`
- Install packages ( `home-manager switch --flake .#yourusername@non-nixos-machine`)

### MacOS

TBD

### NUC

- Install Omarchy
- Configure 1password - login - ssh
- Clone this repository
- Install nix ( single user mode )
- Enable flakes ( `~/.config/nix/nix/conf` )
- Install home-manager ( with flakes )
- Install packages ( `home-manager switch --flake .#yourusername@nuc`)

### Build machine 

TBD
