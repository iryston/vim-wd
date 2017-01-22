" vim: set sw=2 ts=2 sts=2 et tw=0 foldmarker={,} foldlevel=0 foldmethod=marker

" Environment {

  " Identify platform {
    silent function! OSX()
      return has('macunix')
    endfunction
    silent function! LINUX()
      return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
  " }

  " Basics {
    set nocompatible " Must be first line
    set background=dark " Assume a dark background
  " }

  " Arrow Key Fix {
    if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
      inoremap <silent> <C-[>OC <RIGHT>
    endif
  " }

" }

" Bundles {

  " Automatic installation {
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
  " }

  let bundle = '~/.vim/bundle'

  call plug#begin(bundle)

  " Dependences {
    Plug 'MarcWeber/vim-addon-mw-utils' " Various utils such as caching interpreted contents of files
    Plug 'tomtom/tlib_vim' " This library provides some utility functions
    Plug 'godlygeek/csapprox' " Make gvim-only colorschemes work transparently in terminal vim
    if executable('ag')
      Plug 'mileszs/ack.vim'
      let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
    elseif executable('ack-grep')
      let g:ackprg="ack-grep -H --nocolor --nogroup --column"
      Plug 'mileszs/ack.vim'
    elseif executable('ack')
      Plug 'mileszs/ack.vim'
    endif
    Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps with .
    Plug 'nelstrom/vim-qargs' " Qargs utility command, for populating the argument list from the files in the quickfix list
  " }

  " Available bundle groups:
  " ['general', 'colorschemes', 'writing', 'programming', 'codecompletion', 'clojure', 'go', 'haskell', 'html', 'javascript', 'php', 'python', 'ruby', 'scala', 'misc']

    let g:bundle_groups=['general', 'colorschemes', 'writing', 'programming', 'codecompletion', 'html', 'javascript', 'php', 'python', 'ruby', 'misc']

  " General {
    if count(g:bundle_groups, 'general')
      Plug 'vim-airline/vim-airline' " Lean & mean status/tabline for vim that's light as air
      Plug 'bling/vim-bufferline' " Super simple vim plugin to show the list of buffers in the command bar
      Plug 'ctrlpvim/ctrlp.vim' " Full path fuzzy file, buffer, mru, tag, ... finder for Vim
      Plug 'scrooloose/nerdtree', { 'on': '<Plug>NERDTreeTabsToggle' } " A tree explorer plugin for vim
      Plug 'jistr/vim-nerdtree-tabs' " NERDTree and tabs together in Vim, painlessly
      "Plug 'lyokha/vim-xkbswitch'
      Plug 'vim-scripts/matchit.zip' " Extended % matching for HTML, LaTeX, and many other languages
      Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } " Visualize undo-tree
      Plug 'mhinz/vim-signify' " Signs to indicate added, modified and removed lines based on data of an underlying version control system
      Plug 'nathanaelkane/vim-indent-guides' " Visually display indent levels in Vim
      Plug 'osyo-manga/vim-over' " Highlights the {pattern} parameter from |:substitute| {pattern}
      Plug 'terryma/vim-multiple-cursors' " Multiple selections for Vim
      Plug 'tpope/vim-abolish' " Abbreviation, substitution and coercion
      Plug 'tpope/vim-eunuch' " Vim sugar for the UNIX shell commands that need it the most
      Plug 'tpope/vim-surround' " Delete, change and add such surroundings in pairs
      Plug 'vim-scripts/restore_view.vim' " A plugin for automatically restoring file's cursor position and folding
      Plug 'vim-scripts/sessionman.vim' " Work with Vim sessions by keeping them in the dedicated location
      Plug 'rhysd/conflict-marker.vim' " Highlight, Jump and Resolve Conflict Markers Quickly in Vim
      Plug 'tacahiroy/ctrlp-funky' " A simple function navigator for ctrlp.vim
      Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
      Plug 'junegunn/fzf.vim'
    endif
  " }

  " Color Schemes {
    if count(g:bundle_groups, 'colorschemes')
      Plug 'morhetz/gruvbox'
    endif
  " }

  " Writing {
    if count(g:bundle_groups, 'writing')
      Plug 'reedes/vim-litecorrect'
      Plug 'reedes/vim-textobj-sentence'
      Plug 'reedes/vim-textobj-quote'
      Plug 'reedes/vim-wordy'
    endif
  " }

  " General Programming {
    if count(g:bundle_groups, 'programming')
      " Pick one of the checksyntax, jslint, or syntastic
      Plug 'godlygeek/tabular'
      Plug 'mattn/gist-vim'
      Plug 'mattn/webapi-vim'
      Plug 'scrooloose/syntastic'
      Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' } " Comment stuff out
      Plug 'tpope/vim-fugitive'
      if executable('ctags')
        Plug 'majutsushi/tagbar'
      endif
      Plug 'editorconfig/editorconfig-vim'
    endif
  " }

  " Code completion {
    if count(g:bundle_groups, 'codecompletion')
      Plug 'garbas/vim-snipmate'
      Plug 'honza/vim-snippets'
      " Source support_function.vim to support vim-snippets.
      if filereadable(expand("~/.vim/bundle/vim-snippets/snippets/support_functions.vim"))
        source ~/.vim/bundle/vim-snippets/snippets/support_functions.vim
      endif
      Plug 'mattn/emmet-vim', { 'for': 'html' }
    endif
  " }

  " Clojure {
    if count(g:bundle_groups, 'clojure')
      Plug 'kovisoft/paredit', { 'for': 'clojure' }
      Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
      Plug 'guns/vim-clojure-static'
      Plug 'guns/vim-clojure-highlight'
    endif
  " }

  " Go Lang {
    if count(g:bundle_groups, 'go')
      Plug 'fatih/vim-go'
    endif
  " }

  " Haskell {
    if count(g:bundle_groups, 'haskell')
      Plug 'adinapoli/cumino'
      Plug 'bitc/vim-hdevtools'
      Plug 'dag/vim2hs'
      Plug 'eagletmt/ghcmod-vim'
      Plug 'eagletmt/neco-ghc'
      Plug 'lukerandall/haskellmode-vim'
      Plug 'Shougo/vimproc.vim'
      Plug 'travitch/hasksyn'
      Plug 'Twinside/vim-haskellConceal'
      Plug 'Twinside/vim-haskellFold'
    endif
  " }

  " HTML {
    if count(g:bundle_groups, 'html')
      Plug 'ap/vim-css-color'
      Plug 'hail2u/vim-css3-syntax'
      Plug 'tpope/vim-haml'
      Plug 'kewah/vim-stylefmt'
    endif
  " }

  " Javascript {
    if count(g:bundle_groups, 'javascript')
      Plug 'briancollins/vim-jst'
      Plug 'elzr/vim-json'
      Plug 'groenewege/vim-less'
      Plug 'kchmck/vim-coffee-script'
      Plug 'leafgarland/typescript-vim'
      Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
    endif
  " }

  " PHP {
    if count(g:bundle_groups, 'php')
      Plug 'arnaud-lb/vim-php-namespace'
      Plug 'lumiliet/vim-twig'
      Plug 'spf13/PIV'
    endif
  " }

  " Python {
    if count(g:bundle_groups, 'python')
      " Pick either python-mode or pyflakes & pydoc
      "Plug 'klen/python-mode'
      Plug 'pythoncomplete'
      Plug 'python_match.vim'
      Plug 'yssource/python.vim'
      Plug 'Glench/Vim-Jinja2-Syntax'
    endif
  " }

  " Scala {
    if count(g:bundle_groups, 'scala')
      Plug 'derekwyatt/vim-sbt', { 'for': ['scala', 'sbt.scala'] }
      Plug 'derekwyatt/vim-scala', { 'for': ['scala', 'sbt.scala'] }
      Plug 'xptemplate'
    endif
  " }

  " Ruby {
    if count(g:bundle_groups, 'ruby')
      Plug 'tpope/vim-rails', { 'for': [] }
      let g:rubycomplete_buffer_loading = 1
      "let g:rubycomplete_classes_in_global = 1
      "let g:rubycomplete_rails = 1
    endif
  " }

  " Misc {
    if count(g:bundle_groups, 'misc')
      "Plug 'rodjek/vim-puppet'
      Plug 'chrisbra/unicode.vim'
      Plug 'Chiel92/vim-autoformat'
      Plug 'evanmiller/nginx-vim-syntax'
      Plug 'freitass/todo.txt-vim'
      Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
      Plug 'keith/tmux.vim'
      Plug 'mhinz/vim-startify'
      Plug 'quentindecock/vim-cucumber-align-pipes'
      Plug 'rust-lang/rust.vim'
      Plug 'szw/vim-g'
      Plug 'tpope/vim-cucumber'
      Plug 'tpope/vim-markdown'
    endif
  " }
" }

call plug#end()
