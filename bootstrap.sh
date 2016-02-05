#!/bin/sh

#   Copyright 2016 Igor R. Plity
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

############################  SETUP PARAMETERS
app_name='vim-wd'
[ -z "$APP_PATH" ] && APP_PATH="$HOME/.$app_name"
[ -z "$REPO_URI" ] && REPO_URI='https://github.com/iryston/vim-wd.git'
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='master'
debug_mode='1'
[ -z "$BUNDLER_URI" ] && BUNDLER_URI="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
GREEN="\033[1;32m"
RED="\033[1;31m"
ENDCOLOR="\033[0m"

############################  BASIC SETUP TOOLS
msg() {
  printf '%b\n' "$1" >&2
}

success() {
  if [ "$ret" -eq '0' ]; then
    msg "$GREEN [✔] $ENDCOLOR ${1}${2}"
  fi
}

error() {
  msg "$RED [✘] $ENDCOLOR ${1}${2}"
  exit 1
}

debug() {
  if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
    msg "$RED An error occurred in function $ENDCOLOR \"${FUNCNAME[$i+1]}\" $RED on line $ENDCOLOR ${BASH_LINENO[$i+1]}, $RED we're sorry for that $ENDCOLOR"
  fi
}

program_exists() {
  local ret='0'
  command -v $1 >/dev/null 2>&1 || { local ret='1'; }

  # fail on non-zero return value
  if [ "$ret" -ne 0 ]; then
    return 1
  fi

  return 0
}

program_must_exist() {
  program_exists $1

  # throw error on non-zero return value
  if [ "$?" -ne 0 ]; then
    error "You must have '$1' installed to continue"
  fi
}

variable_set() {
  if [ -z "$1" ]; then
    error "You must have your HOME environmental variable set to continue"
  fi
}

lnif() {
  if [ -e "$1" ]; then
    ln -sf "$1" "$2"
  fi
  ret="$?"
  debug
}

############################ SETUP FUNCTIONS

do_backup() {
  if [ -e "$1" ] || [ -e "$2" ] || [ -e "$3" ]; then
    msg "Attempting to back up your original vim configuration"
    today=`date +%Y%m%d_%s`
    for i in "$1" "$2" "$3"; do
      [ -e "$i" ] && [ ! -L "$i" ] && mv -v "$i" "$i.$today";
    done
    ret="$?"
    success "Your original vim configuration has been backed up"
    debug
 fi
}

sync_repo() {
  local repo_path="$1" # "$APP_PATH"
  local repo_uri="$2" # "$REPO_URI"
  local repo_branch="$3" # "$REPO_BRANCH"
  local repo_name="$4" # "$app_name"

  msg "Trying to update $repo_name"

  if [ ! -e "$repo_path" ]; then
    mkdir -p "$repo_path"
    git clone -b "$repo_branch" "$repo_uri" "$repo_path"
    ret="$?"
    success "Successfully cloned $repo_name"
  else
    cd "$repo_path" && git pull origin "$repo_branch"
    ret="$?"
    success "Successfully updated $repo_name"
  fi

  debug
}

create_symlinks() {
  local source_path="$1" # "$APP_PATH"
  local target_path="$2" # "$HOME"

  if [ ! -d "$source_path/.vim/bundle" ]; then
    mkdir -p "$source_path/.vim/bundle"
  fi

  lnif "$source_path/.vimrc"         "$target_path/.vimrc"
  lnif "$source_path/.vimrc.bundles" "$target_path/.vimrc.bundles"
  lnif "$source_path/.vim"           "$target_path/.vim"

  if program_exists "nvim"; then
    lnif "$source_path/.vim"       "$target_path/.config/nvim"
    lnif "$source_path/.vimrc"     "$target_path/.config/nvim/init.vim"
  fi

  ret="$?"
  success "Setting up vim symlinks"
  debug
}

create_tmpdir() {
  local target_path="$1"

  if [ ! -d $target_path/.vim/.tmp ]; then
    mkdir -p $target_path/.vim/.tmp/
  fi
  if [ ! -d $target_path/.vim/.tmp/vimundo ]; then
    mkdir -p $target_path/.vim/.tmp/vimundo/
  fi
  if [ ! -d $target_path/.vim/.tmp/vimviews ]; then
    mkdir -p $target_path/.vim/.tmp/vimviews/
  fi
  if [ ! -d $target_path/.vim/.tmp/vimswap ]; then
    mkdir -p $target_path/.vim/.tmp/vimswap/
  fi
  if [ ! -d $target_path/.vim/.tmp/vimbackup ]; then
    mkdir -p $target_path/.vim/.tmp/vimbackup/
  fi

  success "Making temporary dirs"
  debug
}

add_spellcheck() {
  local target_path="$1" # "$APP_PATH"

  if [ ! -d $target_path/.vim/spell ]; then
    mkdir -p $target_path/.vim/spell/
  fi

  curl 'http://ftp.vim.org/vim/runtime/spell/ru.utf-8.spl' -o "$target_path/.vim/spell/ru.utf-8.spl"
  curl 'http://ftp.vim.org/vim/runtime/spell/ru.utf-8.sug' -o "$target_path/.vim/spell/ru.utf-8.sug"

  success  "Download and install spell files"
  debug
}

install_bundler() {
  local target_path="$1" # "$APP_PATH"

  if [ ! -d $target_path/.vim/autoload ]; then
    mkdir -p $target_path/.vim/autoload/
  fi
  curl -fLo "$target_path/.vim/autoload/plug.vim" --create-dirs "$BUNDLER_URI"

  success  "Download and install Vim plugin manager"
  debug
}
setup_bundler() {
  local system_shell="$SHELL"
  export SHELL='/bin/sh'

  vim \
    -u "$1" \
    "+set nomore" \
    "+PlugInstall" \
    "+PlugClean!" \
    "+qall"

  export SHELL="$system_shell"

  success "Now updating/installing plugins using Vim Plugin Manager"
  debug
}

############################ MAIN()
variable_set "$HOME"
program_must_exist "vim"
program_must_exist "git"
program_must_exist "curl"

do_backup       "$HOME/.vim" \
                "$HOME/.vimrc" \
                "$HOME/.gvimrc"

sync_repo       "$APP_PATH" \
                "$REPO_URI" \
                "$REPO_BRANCH" \
                "$app_name"

create_symlinks "$APP_PATH" \
                "$HOME"

create_tmpdir   "$APP_PATH"

add_spellcheck  "$APP_PATH"

install_bundler "$APP_PATH"

setup_bundler   "$APP_PATH/.vimrc.bundles"

msg             "\nThanks for installing $app_name"
msg             "© `date +%Y` https://github.com/iryston/vim-wd"
