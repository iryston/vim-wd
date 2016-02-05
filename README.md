# VIM for Web Developers

This is VIM configuration for web development.
It supports html, css, javascript, php, ruby, python & more.

### Original idea and a lot of cool staff was taken from [spf13-vim : Steve Francia's Vim Distribution](https://github.com/spf13/spf13-vim)

# Installation

## Linux, \*nix, Mac OSX Installation

The easiest way to install configuration is to use [automatic installer](https://raw.github.com/iryston/vim-wd/master/bootstrap.sh) by simply copying and pasting the following line into a terminal. This will install VIM for Web Developers configuration and backup your existing vim configuration.

*Requires Git 1.7+ and Vim 7.3 or higher.

```bash
curl https://raw.github.com/iryston/vim-wd/master/bootstrap.sh -L > vim-wd.sh && sh vim-wd.sh
```
or
```bash
wget -q https://raw.github.com/iryston/vim-wd/master/bootstrap.sh -O vim-wd.sh && sh vim-wd.sh
```

If you have a bash-compatible shell you can run the script directly:
```bash
sh <(curl https://raw.github.com/iryston/vim-wd/master/bootstrap.sh -L)
```
or
```bash
sh <(wget -q https://raw.github.com/iryston/vim-wd/master/bootstrap.sh -O-)
```

## Updating to the latest version
The simpliest (and safest) way to update is to simply rerun the installer. It will completely and non destructively upgrade to the latest version.

```bash
curl https://raw.github.com/iryston/vim-wd/master/bootstrap.sh -L -o - | sh
```
or use wget if you prefer
```bash
wget -q https://raw.github.com/iryston/vim-wd/master/bootstrap.sh -O- | sh
```

Alternatively you can manually perform the following steps. If anything has changed with the structure of the configuration you will need to create the appropriate symlinks.

```bash
cd $HOME/.vim-wd/
git pull
vim +PlugInstall +PlugClean! +qall
```
