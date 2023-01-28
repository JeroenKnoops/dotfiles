# dotfiles

## Manual installation [Ubuntu 22.04.1 LTS](https://ubuntu.com/download/desktop)

### Git / Curl

```bash
sudo apt-get update
sudo apt-get install git curl
```

```bash
git config --global credential.helper store
git config --global credential.helper cache
```

### ssh-key

Put your ssh key on the appropriate place or even better, create a new key.

### chezmoi

```bash
snap install chezmoi --classic
```
