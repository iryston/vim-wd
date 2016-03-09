" vim: set sw=2 ts=2 sts=2 et tw=0 foldmarker={,} foldlevel=0 foldmethod=marker

" Use bundles config {
  if filereadable(expand("~/.vim/vimrc.bundles.vim"))
    source ~/.vim/vimrc.bundles.vim
  endif
" }

" General {
  set shortmess=atI " Avoid unnecessary hit-enter prompts
  set langmenu=en
  set helplang=en,ru
  set encoding=utf-8
  scriptencoding utf-8
  " Autoset order for file character encodings
  set fileencodings=utf-8,cp1251,koi8-r,cp866
  " For Russian users
  "let g:XkbSwitchEnabled = 1
  set keymap=russian-jcukenwin
  set iskeyword=@,48-57,_,168,184,192-255
  set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
  set iminsert=0
  set imsearch=0

  "highlight Cursor guifg=Black guibg=Green
  "highlight lCursor guifg=NONE guibg=Red

  set nospell                   " Spell checking off
  "au BufNewFile,BufReadPost,FilterReadPost,FileReadPost * set nospell
  set spelllang=ru_yo,en_us
  set fileformat=unix           " Default file format
  set fileformats=unix,dos,mac  " File format detection order
  filetype plugin indent on     " Automatically detect file types.
  syntax on                     " Syntax highlighting
  set synmaxcol=2048            " Syntax coloring too-long lines is slow
  set mouse=a                   " Automatically enable mouse usage
  set mousehide                 " Hide the mouse cursor while typing

  if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
    endif
  endif

  " Most prefer to automatically switch to the current file directory when
  " a new buffer is opened; to prevent this behavior, comment next line
  autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
  " Always switch to the current file directory
  "set complete=.,w,b,u,U
  set autoread " reload files when changed on disk, i.e. via `git checkout`
  set autowrite                       " Automatically write a file when leaving a modified buffer
  set timeoutlen=250 " Time to wait after ESC (default causes an annoying delay)
  set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
  set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
  set virtualedit=onemore             " Allow for cursor beyond last character
  set history=1000                    " Store a ton of history (default is 20)
  set hidden                          " Allow buffer switching without saving

  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " Restore cursor to file position in previous editing session
  function! ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction

  augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
  augroup END

  " Setting up the directories {
  set backup                    " Backups are nice ...
  if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
  endif

  " To disable views comment next lines
  " Add exclusions to mkview and loadview
  " eg: *.*, svn-commit.tmp
  let g:skipview_files = [
        \ '\[example pattern\]'
        \ ]
  " }

" }

" Vim UI {

  set tabpagemax=15               " Only show 15 tabs
  set showmode                    " Display the current mode

  set nocursorline                " Disable highlight of current line
  set lazyredraw                  " do not redraw while running macros (much faster) (LazyRedraw)

  highlight clear SignColumn      " SignColumn should match background
  highlight clear LineNr          " Current line number row will have same background color in relative mode
  let g:CSApprox_hook_post = ['hi clear SignColumn']
  highlight clear CursorLineNr    " Remove highlight color from current line number

  if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
    " Selected characters/lines in visual mode
  endif

  if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif

  set backspace=indent,eol,start  " Intuitive backspacing
  set linespace=0                 " No extra spaces between rows
  set nu                          " Line numbers on
  set noshowmatch                 " Don't show matching brackets/parenthesis
  set matchpairs+=<:>,[:]         " Match, to be used with %
  set matchtime=6                 " Bracket blinking
  let loaded_matchparen = 1
  set incsearch                   " Find as you type search
  set hlsearch                    " Highlight search terms
  set winminheight=0              " Windows can be 0 line high
  set ignorecase                  " Case insensitive search
  set smartcase                   " Case sensitive when capital letter present
  set wildmenu                    " Show list instead of just completing
  set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all
  set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
  set scrolljump=1                " Lines to scroll when cursor leaves screen
  set scrolloff=2                 " Minimum lines to keep above and below cursor
  set display+=lastline           " Display as much as possibe of a window's last line
  set nofoldenable                " Turn off folding
  set foldmethod=manual           " folds must be defined by entering commands (such as v{motion}zf)
  set foldlevel=99                " Don't autofold anything (but I can still fold manually)
  set listchars=tab:›\ ,eol:¶,trail:•,extends:»,precedes:«,nbsp:. " Highlight problematic whitespace
  set nolist                      " Display unprintable characters <C-h> - switches

" }

" Formatting {

  set nowrap                      " Do not wrap long lines
  set autoindent                  " Indent at the same level of the previous line
  set shiftwidth=2                " Use indents of 2 spaces
  set expandtab                   " Tabs are spaces, not tabs
  set tabstop=2                   " An indentation every four columns
  set softtabstop=2               " Let backspace delete indent
  set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
  set splitright                  " Puts new vsplit windows to the right of the current
  set splitbelow                  " Puts new split windows to the bottom of the current
  set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
  "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
  " Remove trailing whitespaces and ^M chars
  autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  autocmd FileType go autocmd BufWritePre <buffer> Fmt
  autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
  autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
  " preceding line best in a plugin but here for now.

  autocmd BufNewFile,BufRead *.coffee set filetype=coffee

  " Workaround vim-commentary for Haskell
  autocmd FileType haskell setlocal commentstring=--\ %s
  " Workaround broken colour highlighting in Haskell & Rust
  autocmd FileType haskell,rust setlocal nospell

  set ttyfast

" }

" Key (re)Mappings {

  "let mapleader = '\' " The default leader is '\'
  let mapleader      = ' '
  let maplocalleader = ' '

  " Wrapped lines goes down/up to next row, rather than next line in file.
  noremap j gj
  noremap k gk

  " End/Start of line motion keys act relative to row/wrap width in the
  " presence of `:set wrap`, and relative to line for `:set nowrap`.
  " Default vim behaviour is to act relative to text line in both cases
  " Same for 0, home, end, etc
  function! WrapRelativeMotion(key, ...)
    let vis_sel=""
    if a:0
      let vis_sel="gv"
    endif
    if &wrap
      execute "normal!" vis_sel . "g" . a:key
    else
      execute "normal!" vis_sel . a:key
    endif
  endfunction

  " Map g* keys in Normal, Operator-pending, and Visual+select
  noremap $ :call WrapRelativeMotion("$")<CR>
  noremap <End> :call WrapRelativeMotion("$")<CR>
  noremap 0 :call WrapRelativeMotion("0")<CR>
  noremap <Home> :call WrapRelativeMotion("0")<CR>
  noremap ^ :call WrapRelativeMotion("^")<CR>
  " Overwrite the operator pending $/<End> mappings from above
  " to force inclusive motion with :execute normal!
  onoremap $ v:call WrapRelativeMotion("$")<CR>
  onoremap <End> v:call WrapRelativeMotion("$")<CR>
  " Overwrite the Visual+select mode mappings from above
  " to ensure the correct vis_sel flag is passed to function
  vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
  vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
  vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
  vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
  vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

  " Stupid shift key fixes
  if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
  endif

  cmap Tabe tabe

  " Code folding options
  nmap <leader>f0 :set foldlevel=0<CR>
  nmap <leader>f1 :set foldlevel=1<CR>
  nmap <leader>f2 :set foldlevel=2<CR>
  nmap <leader>f3 :set foldlevel=3<CR>
  nmap <leader>f4 :set foldlevel=4<CR>
  nmap <leader>f5 :set foldlevel=5<CR>
  nmap <leader>f6 :set foldlevel=6<CR>
  nmap <leader>f7 :set foldlevel=7<CR>
  nmap <leader>f8 :set foldlevel=8<CR>
  nmap <leader>f9 :set foldlevel=9<CR>

  "UPPERCASE and lowercase conversion
  "nnoremap g^ gUiW
  "nnoremap gv guiW

  "go to first and last char of line
  "nnoremap H ^
  "nnoremap L g_
  "vnoremap H ^
  "vnoremap L g_

  " Most prefer to toggle search highlighting rather than clear the current
  " search results. To clear search highlighting rather than toggle it on
  " and off, uncomment next line
  "   nmap <silent> <leader>/ :nohlsearch<CR>
  " and comment the next one
  nmap <silent> <leader>/ :set invhlsearch<CR>

  " Find merge conflict markers
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Shortcuts
  " Change Working Directory to that of the current file
  cmap cwd lcd %:p:h
  cmap cd. lcd %:p:h

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<CR>

  " Some helpers to edit mode
  " http://vimcasts.org/e/14
  cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
  map <leader>ew :e %%
  map <leader>es :sp %%
  map <leader>ev :vsp %%
  map <leader>et :tabe %%

  " Adjust viewports to the same size
  map <Leader>= <C-w>=

  " Map <Leader>ff to display all lines with keyword under cursor
  " and ask which one to jump to
  nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

  " Easier horizontal scrolling
  map zl zL
  map zh zH

  " Easier formatting
  nnoremap <silent> <leader>q gwip
  " show/Hide hidden Chars
  map <silent> <C-h> :set invlist<CR>

  " Easier switch background between dark and light
  nnoremap cob :set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR>

" }

" Plugins {

  " PIV {
    if isdirectory(expand("~/.vim/bundle/PIV"))
      let g:DisableAutoPHPFolding = 1
      let g:PIVAutoClose = 0
    endif
  " }

  " Qargs {
    command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
    function! QuickfixFilenames()
      " Building a hash ensures we get each buffer only once
      let buffer_numbers = {}
      for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
      endfor
      return join(values(buffer_numbers))
    endfunction
  " }

  " Misc {
    if isdirectory(expand("~/.vim/bundle/nerdtree"))
      let g:NERDShutUp=1
    endif
    if isdirectory(expand("~/.vim/bundle/matchit.zip"))
      let b:match_ignorecase = 1
    endif
  " }

  " Emmet {
    let g:user_emmet_leader_key='<C-E>'
  " }

  " Ctags {
    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
      let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
  " }

  " AutoCloseTag {
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nmap <Leader>ac <Plug>ToggleAutoCloseMappings
  " }

  " SnipMate {
    " Setting the author var
    let g:snips_author = 'Igor R. Plity <iryston@iryston.net>'
  " }

  " Syntastic {
    " run the php checker first, and if no errors are found, run phpcs, and then phpmd
    let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']
  " }

  " NerdTree {
    if isdirectory(expand("~/.vim/bundle/nerdtree"))
      map <F9> <Plug>NERDTreeTabsToggle<CR>
      map <leader>e :NERDTreeFind<CR>
      nmap <leader>nt :NERDTreeFind<CR>

      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
      let NERDTreeChDirMode=0
      let NERDTreeQuitOnOpen=1
      let NERDTreeMouseMode=2
      let NERDTreeShowHidden=1
      let NERDTreeKeepTreeInNewTab=1
      let g:nerdtree_tabs_open_on_gui_startup=0
      let g:NERDTreeBookmarksFile = $HOME . '/.vim/local/.NERDTreeBookmarks'
    endif
  " }

  " Tabularize {
    if isdirectory(expand("~/.vim/bundle/tabular"))
      nmap <Leader>a& :Tabularize /&<CR>
      vmap <Leader>a& :Tabularize /&<CR>
      nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
      vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
      nmap <Leader>a=> :Tabularize /=><CR>
      vmap <Leader>a=> :Tabularize /=><CR>
      nmap <Leader>a: :Tabularize /:<CR>
      vmap <Leader>a: :Tabularize /:<CR>
      nmap <Leader>a:: :Tabularize /:\zs<CR>
      vmap <Leader>a:: :Tabularize /:\zs<CR>
      nmap <Leader>a, :Tabularize /,<CR>
      vmap <Leader>a, :Tabularize /,<CR>
      nmap <Leader>a,, :Tabularize /,\zs<CR>
      vmap <Leader>a,, :Tabularize /,\zs<CR>
      nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
      vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    endif
  " }

  " Session List {
    set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
      nmap <leader>sl :SessionList<CR>
      nmap <leader>ss :SessionSave<CR>
      nmap <leader>sc :SessionClose<CR>
    endif
  " }

  " JSON {
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0
  " }

  " PyMode {
    " Disable if python support not present
    if !has('python')
      let g:pymode = 0
    endif

    if isdirectory(expand("~/.vim/bundle/python-mode"))
      let g:pymode_lint_checkers = ['pyflakes']
      let g:pymode_trim_whitespaces = 0
      let g:pymode_options = 0
      let g:pymode_rope = 0
    endif
  " }

  " ctrlp {
    if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
      let g:ctrlp_working_path_mode = 'ra'
      nnoremap <silent> <D-t> :CtrlP<CR>
      nnoremap <silent> <D-r> :CtrlPMRU<CR>
      let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

      if executable('ag')
        let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
      elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
      elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
      else
        let s:ctrlp_fallback = 'find %s -type f'
      endif
      let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': s:ctrlp_fallback
            \ }

    endif
  "}

  " TagBar {
    if isdirectory(expand("~/.vim/bundle/tagbar/"))
      nnoremap <silent> <leader>tt :TagbarToggle<CR>
    endif
  "}


  " Fugitive {
    if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
      nnoremap <silent> <leader>gs :Gstatus<CR>
      nnoremap <silent> <leader>gd :Gdiff<CR>
      nnoremap <silent> <leader>gc :Gcommit<CR>
      nnoremap <silent> <leader>gb :Gblame<CR>
      nnoremap <silent> <leader>gl :Glog<CR>
      nnoremap <silent> <leader>gp :Git push<CR>
      nnoremap <silent> <leader>gr :Gread<CR>
      nnoremap <silent> <leader>gw :Gwrite<CR>
      nnoremap <silent> <leader>ge :Gedit<CR>
      " Mnemonic _i_nteractive
      nnoremap <silent> <leader>gi :Git add -p %<CR>
      nnoremap <silent> <leader>gg :SignifyToggle<CR>
    endif
  "}

  " Normal Vim omni-completion {
    " To disable omni complete, comment next lines:
    " Enable omni-completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
  " }

  " FIXME: Isn't this for Syntastic to handle?
  " Haskell post write lint and check with ghcmod
  " $ `cabal install ghcmod` if missing and ensure
  " ~/.cabal/bin is in your $PATH.
  if !executable("ghcmod")
    autocmd BufWritePost *.hs GhcModCheckAndLintAsync
  endif

  " UndoTree {
    if isdirectory(expand("~/.vim/bundle/undotree/"))
      nnoremap <Leader>u :UndotreeToggle<CR>
      " If undotree is opened, it is likely one wants to interact with it.
      let g:undotree_SetFocusWhenToggle=1
    endif
  " }

  " indent_guides {
    if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
      let g:indent_guides_start_level = 2
      let g:indent_guides_guide_size = 1
      let g:indent_guides_enable_on_vim_startup = 1
    endif
  " }

  " vim-commentary {
    map  gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine
  " }

  " Wildfire {
    let g:wildfire_objects = {
          \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
          \ "html,xml" : ["at"],
        \ }
  " }

  " vim-airline {
    " Set configuration options for the statusline plugin vim-airline.
    " Use the powerline theme and optionally enable powerline symbols.
    " To use the symbols , , , , , , and .in the statusline
    " segments uncomment the following line:
    let g:airline_powerline_fonts=1
    " If the previous symbols do not render for you then install a
    " powerline enabled font.

    " See `:echo g:airline_theme_map` for some more choices
    " Default in terminal vim is 'dark'
    if isdirectory(expand("~/.vim/bundle/vim-airline/"))
      if !exists('g:airline_theme')
        let g:airline_theme = 'gruvbox'
      endif
      if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='›'  " Slightly fancier than '>'
        let g:airline_right_sep='‹' " Slightly fancier than '<'
      endif
    endif
  " }

" }

" GUI Settings {

  " GVIM- (here instead of .gvimrc)
  if has('gui_running')
    set guioptions-=T           " Remove the toolbar
    set lines=40                " 40 lines of text instead of 24
    if LINUX() && has("gui_running")
      set guifont=Input\ Mono\ Regular\ 11,Cousine\ Regular\ 13,Monospace\ Regular\ 11,Ubuntu\ Mono\ Regular\ 13,Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
    elseif OSX() && has("gui_running")
      set guifont=Input\ Mono\ Regular:h14,Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
    elseif WINDOWS() && has("gui_running")
      set guifont=Input_Mono:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
    endif
    set background=dark
    colorscheme gruvbox
    "LuciusBlackLowContrast
  else
    if &term == 'xterm' || &term == 'xterm-256color' || &term == 'screen'
      set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
      "let &t_SI = "\<Esc>]12;Blue\x7"
      "let &t_EI = "\<Esc>]12;NavyBlue\x7"
    endif
    set background=dark
    colorscheme gruvbox
    "LuciusBlackLowContrast
    "set term=builtin_ansi       " Make arrow and other keys work
  endif
  "autocmd InsertEnter * set cul
  "autocmd InsertLeave * set nocul
  "   au InsertLeave * hi Cursor guifg=Black guibg=Green ctermfg=Black ctermbg=Green
  "  au InsertEnter * hi Cursor guifg=Black guibg=Red ctermfg=Black ctermbg=Red

  set noshowmode " Don't show the mode since Powerline shows it
  set title " Set the title of the window in the terminal to the file
  set noequalalways " Resize windows as little as possible

  " Encoding menu {
    " Choose encoding for loading fle
    set wildmenu
    set wcm=<Tab>
    menu Encoding.Read.utf-8<Tab><F7> :e ++enc=utf8 <CR>
    menu Encoding.Read.windows-1251<Tab><F7> :e ++enc=cp1251<CR>
    menu Encoding.Read.koi8-r<Tab><F7> :e ++enc=koi8-r<CR>
    menu Encoding.Read.cp866<Tab><F7> :e ++enc=cp866<CR>
    map <F7> :emenu Encoding.Read.<TAB>

    " Choose encoding for save file
    set wildmenu
    set wcm=<Tab>
    menu Encoding.Write.utf-8<Tab><S-F7> :set fenc=utf8 <CR>
    menu Encoding.Write.windows-1251<Tab><S-F7> :set fenc=cp1251<CR>
    menu Encoding.Write.koi8-r<Tab><S-F7> :set fenc=koi8-r<CR>
    menu Encoding.Write.cp866<Tab><S-F7> :set fenc=cp866<CR>
    map <S-F7> :emenu Encoding.Write.<TAB>

    " Choose line endings (dos - <CR><NL>, unix - <NL>, mac - <CR>)
    set wildmenu
    set wcm=<Tab>
    menu Encoding.End_line_format.unix<Tab><C-F7> :set fileformat=unix<CR>
    menu Encoding.End_line_format.dos<Tab><C-F7> :set fileformat=dos<CR>
    menu Encoding.End_line_format.mac<Tab><C-F7> :set fileformat=mac<CR>
    map <C-F7> :emenu Encoding.End_line_format.<TAB>
  " }

" }

" Functions {

  " Initialize directories {
    function! InitializeDirectories()
      let parent = $HOME
      let prefix = 'vim'
      let dir_list = {
            \ 'backup': 'backupdir',
            \ 'views': 'viewdir',
            \ 'swap': 'directory' }

      if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
      endif

      let common_dir = $HOME . '/.vim/.tmp/' . prefix

      for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
          if !isdirectory(directory)
            call mkdir(directory)
          endif
        endif
        if !isdirectory(directory)
          echo "Warning: Unable to create backup directory: " . directory
          echo "Try: mkdir -p " . directory
        else
          let directory = substitute(directory, " ", "\\\\ ", "g")
          exec "set " . settingname . "=" . directory
        endif
      endfor
    endfunction
    call InitializeDirectories()
  " }

  " Initialize NERDTree as needed {
    " function! NERDTreeInitAsNeeded()
    "   redir => bufoutput
    "   buffers!
    "   redir END
    "   let idx = stridx(bufoutput, "NERD_tree")
    "   if idx > -1
    "     NERDTreeMirror
    "     NERDTreeFind
    "     wincmd l
    "   endif
    " endfunction
  " }

  " Strip whitespace {
    function! StripTrailingWhitespace()
      " Preparation: save last search, and cursor position.
      let _s=@/
      let l = line(".")
      let c = col(".")
      " do the business:
      %s/\s\+$//e
      " clean up: restore previous search history, and cursor position
      let @/=_s
      call cursor(l, c)
    endfunction
  " }

  " Shell command {
    function! s:RunShellCommand(cmdline)
      botright new

      setlocal buftype=nofile
      setlocal bufhidden=delete
      setlocal nobuflisted
      setlocal noswapfile
      setlocal nowrap
      setlocal filetype=shell
      setlocal syntax=shell

      call setline(1, a:cmdline)
      call setline(2, substitute(a:cmdline, '.', '=', 'g'))
      execute 'silent $read !' . escape(a:cmdline, '%#')
      setlocal nomodifiable
      1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
  " }

" }
