" vim: set sw=2 ts=2 sts=2 et tw=0 foldmarker={,} foldlevel=0 foldmethod=marker

" ############################################################################
" Environment {
" ############################################################################

  " --------------------------------------------------------------------------
  " Identify platform {
  " --------------------------------------------------------------------------
    silent function! OSX()
      return (has('mac') || has('macunix'))
    endfunction
    silent function! LINUX()
      return (has('unix') && !has('macunix') && !has('win32unix'))
    endfunction
    silent function! WINDOWS()
      return (has('win32') || has('win64'))
    endfunction
  " }

  " --------------------------------------------------------------------------
  " Basics {
  " --------------------------------------------------------------------------
    " Must be first line
    set nocompatible
    " Assume a dark background
    set background=dark
  " }

  " --------------------------------------------------------------------------
  " Windows Compatible {
  " --------------------------------------------------------------------------
    " On Windows, also use '.vim' instead of 'vimfiles';
    " This makes synchronization across (heterogeneous) systems easier.
    if WINDOWS()
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
    endif
  " }

  " --------------------------------------------------------------------------
  " Arrow Key Fix {
  " --------------------------------------------------------------------------
    if &term[:4] == 'xterm' || &term[:5] == 'screen' || &term[:3] == 'rxvt'
      inoremap <silent> <C-[>OC <RIGHT>
    endif
  " }

" }

" ############################################################################
" Bundles {
" ############################################################################

  " --------------------------------------------------------------------------
  " Automatic installation {
  " --------------------------------------------------------------------------
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall | source $MYVIMRC
    endif
  " }

  let bundle = '~/.vim/bundle'

  call plug#begin(bundle)

  " --------------------------------------------------------------------------
  " Dependences {
  " --------------------------------------------------------------------------
    " Make gvim-only colorschemes work transparently in terminal vim
    Plug 'godlygeek/csapprox'
    " Various utils such as caching interpreted contents of files
    Plug 'MarcWeber/vim-addon-mw-utils'
    " Qargs utility command, for populating the argument list from the files in the quickfix list
    Plug 'nelstrom/vim-qargs'
    " This library provides some utility functions
    Plug 'tomtom/tlib_vim'
    " Enable repeating supported plugin maps with .
    Plug 'tpope/vim-repeat'
    if executable('ag')
      Plug 'mileszs/ack.vim'
      let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
    elseif executable('ack-grep')
      Plug 'mileszs/ack.vim'
      let g:ackprg = 'ack-grep -H --nocolor --nogroup --column'
    elseif executable('ack')
      Plug 'mileszs/ack.vim'
    endif
  " }

  " --------------------------------------------------------------------------
  " Available bundle groups:
  " --------------------------------------------------------------------------
  let g:bundle_groups = ['']
  " Uncomment nesesary groups below
  call add(g:bundle_groups, 'general')
  " call add(g:bundle_groups, 'clojure')
  call add(g:bundle_groups, 'codecompletion')
  call add(g:bundle_groups, 'colorschemes')
  call add(g:bundle_groups, 'go')
  " call add(g:bundle_groups, 'haskell')
  call add(g:bundle_groups, 'html')
  call add(g:bundle_groups, 'javascript')
  call add(g:bundle_groups, 'misc')
  call add(g:bundle_groups, 'php')
  call add(g:bundle_groups, 'programming')
  call add(g:bundle_groups, 'python')
  call add(g:bundle_groups, 'ruby')
  " call add(g:bundle_groups, 'rust')
  " call add(g:bundle_groups, 'scala')
  call add(g:bundle_groups, 'tmux')
  call add(g:bundle_groups, 'writing')

  " --------------------------------------------------------------------------
  " General {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'general')
      " Full path fuzzy file, buffer, mru, tag, ... finder for Vim
      Plug 'ctrlpvim/ctrlp.vim'
      if v:version >= 800
        " An ack.vim alternative mimics Ctrl-Shift-F on Sublime Text 2
        Plug 'dyng/ctrlsf.vim'
      endif
      " A command-line fuzzy finder written in Go
      if isdirectory('/usr/local/opt/fzf')
        Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
      else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
        Plug 'junegunn/fzf.vim'
      endif
      " A set of mappings for enhancing in-buffer search experience in Vim
      Plug 'junegunn/vim-slash'
      " Opens the file manager or terminal at the directory of the current file in Vim.
      Plug 'justinmk/vim-gtfo'
      " Visualize undo-tree
      Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
      " Signs to indicate changes in lines based on data of an underlying VCS
      Plug 'mhinz/vim-signify'
      " Visually display indent levels in Vim
      Plug 'nathanaelkane/vim-indent-guides'
      " Highlights the {pattern} parameter from |:substitute| {pattern}
      Plug 'osyo-manga/vim-over'
      " Highlight, Jump and Resolve Conflict Markers Quickly in Vim
      Plug 'rhysd/conflict-marker.vim'
      " A tree explorer plugin for vim
      Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle'] }
      " A solid language pack for Vim
      Plug 'sheerun/vim-polyglot'
      " A simple function navigator for ctrlp.vim
      Plug 'tacahiroy/ctrlp-funky'
      " Abbreviation, substitution and coercion
      Plug 'tpope/vim-abolish'
      " Vim sugar for the UNIX shell commands that need it the most
      Plug 'tpope/vim-eunuch'
      " Delete, change and add such surroundings in pairs
      Plug 'tpope/vim-surround'
      " Extended % matching for HTML, LaTeX, and many other languages
      Plug 'andymass/vim-matchup'
      " A plugin for automatically restoring file's cursor position and folding
      Plug 'vim-scripts/restore_view.vim'
      " Work with Vim sessions by keeping them in the dedicated location
      Plug 'vim-scripts/sessionman.vim'
    endif
  " }

  " --------------------------------------------------------------------------
  " Color Schemes {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'colorschemes')
      Plug 'iryston/cosmic_latte'
    endif
  " }

  " --------------------------------------------------------------------------
  " General Programming {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'programming')
     " Perform diffs on blocks of code
      Plug 'AndrewRadev/linediff.vim'
      " Simplify the transition between multiline and single-line code
      Plug 'AndrewRadev/splitjoin.vim'
      " EditorConfig plugin for Vim http://editorconfig.org
      Plug 'editorconfig/editorconfig-vim'
      " Vim script for text filtering and alignment
      Plug 'godlygeek/tabular'
      " A git commit browser
      Plug 'junegunn/gv.vim', { 'on': 'GV' }
      " Vim script for creating gists
      Plug 'mattn/gist-vim'
      " An Interface to WEB APIs
      Plug 'mattn/webapi-vim'
      " A Vim plugin for more pleasant editing on commit messages
      Plug 'rhysd/committia.vim'
      " Comment stuff out, takes a motion as a target
      Plug 'tpope/vim-commentary', { 'on': [ '<Plug>Commentary', '<Plug>CommentaryLine' ] }
      " A Git wrapper
      Plug 'tpope/vim-fugitive'
      " Asynchronous Lint Engine is a plugin for providing linting in NeoVim and Vim 8
      Plug 'w0rp/ale'
      " Syntax checking hacks for vim
      Plug 'vim-syntastic/syntastic', { 'on': [ 'SyntasticCheck', 'SyntasticInfo', 'SyntasticToggleMode' ] }
      if executable('ctags')
        " A class outline viewer for Vim
        Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
      endif
    endif
  " }

  " --------------------------------------------------------------------------
  " Code completion {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'codecompletion')
      Plug 'garbas/vim-snipmate'
      Plug 'honza/vim-snippets'
      " Source support_function.vim to support vim-snippets.
      if filereadable(expand('~/.vim/bundle/vim-snippets/snippets/support_functions.vim'))
        source ~/.vim/bundle/vim-snippets/snippets/support_functions.vim
      endif
    endif
  " }

  " --------------------------------------------------------------------------
  " Clojure {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'clojure')
      Plug 'guns/vim-clojure-highlight'
      Plug 'guns/vim-clojure-static'
      Plug 'kovisoft/paredit', { 'for': 'clojure' }
      Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
    endif
  " }

  " --------------------------------------------------------------------------
  " Go Lang {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'go')
      if executable('go')
        " To update all Go dependencies run :GoUpdateBinaries
        Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
      endif
    endif
  " }

  " --------------------------------------------------------------------------
  " Haskell {
  " --------------------------------------------------------------------------
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

  " --------------------------------------------------------------------------
  " HTML {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'html')
      " Plug 'ap/vim-css-color', { 'for': ['css', 'html', 'less', 'sass', 'scss', 'stylus'] }
      " Plug 'digitaltoad/vim-pug', { 'for': ['html', 'pug'] }
      " Plug 'hail2u/vim-css3-syntax'
      Plug 'mattn/emmet-vim', { 'for': ['css', 'html', 'htmldjango', 'jinja', 'xsl'] }
      " Plug 'tpope/vim-haml'
    endif
  " }

  " --------------------------------------------------------------------------
  " Javascript {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'javascript')
      Plug 'briancollins/vim-jst'
      Plug 'elzr/vim-json'
      Plug 'groenewege/vim-less'
      Plug 'kchmck/vim-coffee-script'
      Plug 'leafgarland/typescript-vim'
      Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
    endif
  " }

  " --------------------------------------------------------------------------
  " PHP {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'php')
      Plug 'arnaud-lb/vim-php-namespace'
      Plug 'lumiliet/vim-twig'
      Plug 'spf13/PIV'
    endif
  " }

  " --------------------------------------------------------------------------
  " Python {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'python')
      Plug 'Glench/Vim-Jinja2-Syntax'
      Plug 'yssource/python.vim'
    endif
  " }

  " --------------------------------------------------------------------------
  " Scala {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'scala')
      Plug 'derekwyatt/vim-sbt', { 'for': ['scala', 'sbt.scala'] }
      Plug 'derekwyatt/vim-scala', { 'for': ['scala', 'sbt.scala'] }
      Plug 'xptemplate'
    endif
  " }

  " --------------------------------------------------------------------------
  " Ruby {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'ruby')
      Plug 'tpope/vim-rails', { 'for': [] }
      let g:rubycomplete_buffer_loading = 1
      "let g:rubycomplete_classes_in_global = 1
      "let g:rubycomplete_rails = 1
    endif
  " }

  " --------------------------------------------------------------------------
  " Rust {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'rust')
      Plug 'rust-lang/rust.vim'
    endif
  " }

  " --------------------------------------------------------------------------
  " Tmux {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'tmux')
      Plug 'keith/tmux.vim'
      Plug 'tpope/vim-tbone'
    endif
  " }

  " --------------------------------------------------------------------------
  " Writing {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'writing')
      Plug 'reedes/vim-litecorrect'
      Plug 'reedes/vim-textobj-quote'
      Plug 'reedes/vim-textobj-sentence'
      Plug 'reedes/vim-wordy'
    endif
  " }

  " --------------------------------------------------------------------------
  " Misc {
  " --------------------------------------------------------------------------
    if count(g:bundle_groups, 'misc')
      Plug 'Chiel92/vim-autoformat'
      Plug 'chrisbra/unicode.vim'
      Plug 'freitass/todo.txt-vim'
      " Plug 'https://gitlab.com/dbeniamine/todo.txt-vim'
      Plug 'honza/dockerfile.vim'
      Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
      Plug 'mhinz/vim-startify'
      Plug 'quentindecock/vim-cucumber-align-pipes'
      Plug 'szw/vim-g'
      Plug 'tpope/vim-cucumber'
      Plug 'tpope/vim-markdown'
    endif
  " }
" }

call plug#end()
