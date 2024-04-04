# dotfiles

This repo contains the configuration to setup my machines. This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

This automated setup is currently only configured for Mac machines.

## How to run

(optional) set sudo to not use password to make the install more "automatic" using ```sudo visudo```

```shell
# original
# %admin ALL=(ALL) ALL
%admin ALL=(ALL) NOPASSWD: ALL
```

AFTER FINISH CHANGE BACK TO THE ORIGINAL SUDO

```shell
export GITHUB_USERNAME=rodrigogsilva
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

### note

For new installs, xcode commandline developer tools is needed

```shell
xcode-select --install
```
