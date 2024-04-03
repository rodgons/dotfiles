# dotfiles

This repo contains the configuration to setup my machines. This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

This automated setup is currently only configured for Mac machines.

## How to run

```shell
export GITHUB_USERNAME=rodrigogsilva
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

### note

For new installs, xcode commandline developer tools is needed

```shell
xcode-select --install
```
