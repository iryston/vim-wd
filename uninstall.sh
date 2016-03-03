#!/usr/bin/env bash

app_dir="$HOME/.vim-wd"

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

rm $HOME/.vimrc
rm $HOME/.vim

rm -rf $app_dir
