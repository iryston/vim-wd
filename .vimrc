" vim: set sw=2 ts=2 sts=2 et tw=0 foldmarker={,} foldlevel=0 foldmethod=marker:

" ############################################################################
"  Includes
" ############################################################################

" ----------------------------------------------------------------------------
" Use bundles config {
" ----------------------------------------------------------------------------
if filereadable(expand('~/.vim/vimrc.bundles.vim'))
  source ~/.vim/vimrc.bundles.vim
endif
" }

" ############################################################################
" General {
" ############################################################################

" Avoid unnecessary hit-enter prompts
set shortmess=atI
set langmenu=en
set helplang=en,ru
set encoding=utf-8
scriptencoding utf-8
" Autoset order for file character encodings
set fileencodings=utf-8,cp1251,koi8-r,cp866
" For Russian users
set keymap=russian-jcukenwin
set iskeyword=@,48-57,_,168,184,192-255
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;
      \`qwertyuiop[]asdfghjkl\\;
      \'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
set iminsert=0
set imsearch=0

"highlight Cursor guifg=Black guibg=Green
"highlight lCursor guifg=NONE guibg=Red

" Spell checking off
set nospell
"au BufNewFile,BufReadPost,FilterReadPost,FileReadPost * set nospell
set spelllang=ru_yo,en_us
" Default file format
set fileformat=unix
" File format detection order
set fileformats=unix,dos,mac
" Automatically detect file types.
filetype plugin indent on
" Syntax highlighting
syntax on
" Syntax coloring too-long lines is slow
set synmaxcol=2048
" Automatically enable mouse usage
set mouse=a
" Hide the mouse cursor while typing
set mousehide

if has('clipboard')
  if has('unnamedplus')  " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else         " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
endif

" Shift-tab on GNU screen
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

" Most prefer to automatically switch to the current file directory when
" a new buffer is opened; to prevent this behavior, comment next line
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
" Always switch to the current file directory
"set complete=.,w,b,u,U
set complete-=i
" Reload files when changed on disk, i.e. via `git checkout`
set autoread
" Automatically write a file when leaving a modified buffer
set autowrite
" Time to wait after ESC (default causes an annoying delay)
set timeoutlen=500
" Abbrev. of messages (avoids 'hit enter')
set shortmess+=filmnrxoOtT
" Better Unix / Windows compatibility
set viewoptions=folds,options,cursor,unix,slash
" Allow for cursor beyond last character
set virtualedit=onemore
" Start diff mode with vertical splits
set diffopt=filler,vertical
" Store a ton of history (default is 20)
set history=1000
" Allow buffer switching without saving
set hidden
set modelines=2
set nrformats=hex
" 80,120 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80,120
endif

" Keep the cursor on the same column
set nostartofline

set formatoptions+=1
if has('patch-7.3.541')
  set formatoptions+=j
endif
if has('patch-7.4.338')
  let &showbreak = '↳ '
  set breakindent
  set breakindentopt=sbr
endif

" FOOBAR=~/<CTRL-><CTRL-F>
set isfname-==

if exists('&fixeol')
  set nofixeol
endif

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Add spell checking and automatic wrapping at the recommended 72 columns to commit messages
au Filetype gitcommit setlocal spell textwidth=72

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
function! ResCur()
  if line("'\"") <= line('$')
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Setting up the directories {
" Backups are nice ...
set backup
if has('persistent_undo')
  " So is persistent undo ...
  set undofile
  " Maximum number of changes that can be undone
  set undolevels=1000
  " Maximum number lines to save for undo on a buffer reload
  set undoreload=10000
endif

" To disable views comment next lines
" Add exclusions to mkview and loadview
" eg: *.*, svn-commit.tmp
let g:skipview_files = [
      \ '\[example pattern\]'
      \ ]
" }

" }

" ############################################################################
" Vim UI {
" ############################################################################

" Only show 15 tabs
set tabpagemax=15
" Disable highlight of current line
set nocursorline
" Do not redraw while running macros (much faster) (LazyRedraw)
set lazyredraw

" SignColumn should match background
highlight clear SignColumn
" Current line number row will have same background color in relative mode
highlight clear LineNr
highlight clear CursorLineNr
" Remove highlight color from current line number
let g:CSApprox_hook_post = ['hi clear SignColumn']

if has('cmdline_info')
" Show the ruler
  set ruler
" A ruler on steroids
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
" Show partial commands in status line and selected characters/lines in visual mode
  set showcmd
endif

set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left':  [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'],
      \              ['syntastic'], ['trailingspace'], ['indentmix'] ],
      \   'right': [ [ 'bufinfo', 'lineinfo', 'percent' ],
      \              [ 'codeblock', 'fileformat', 'fileencoding', 'filetype', 'filesize' ] ]
      \ },
      \ 'component': {
      \       'lineinfo': '%c:%l/%L',
      \      'indentmix': '%#error#%{LightlineTabWarning()}',
      \  'trailingspace': '%#error#%{LightlineTrailingSpaceWarning()}',
      \ },
      \ 'component_function': {
      \           'mode': 'LightlineMode',
      \        'bufinfo': 'LightlineBufInfo',
      \       'filename': 'LightlineFilename',
      \       'filesize': 'LightlineFilesize',
      \       'filetype': 'LightlineFiletype',
      \       'fugitive': 'LightlineFugitive',
      \      'codeblock': 'LightlineCurrentblock',
      \      'ctrlpmark': 'CtrlPMark',
      \     'fileformat': 'LightlineFileformat',
      \   'fileencoding': 'LightlineFileencoding',
      \ },
      \ 'component_expand': {
      \      'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \      'indentmix': 'raw',
      \      'syntastic': 'error',
      \  'trailingspace': 'raw',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightlineBufInfo()
  let last_buf_nr = len(filter(range(1,bufnr('$')),'buflisted(v:val)'))
  let cur_buf_nr = bufnr('%')
  return 'B#' . cur_buf_nr . '/' . last_buf_nr
endfunction

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  let nr = bufnr('')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

" Find out current buffer's size and output it.
function!  LightlineFilesize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc).(&bomb ? ',BOM' : '') : ''
endfunction

"return the syntax highlight group under the cursor ''
function! LightlineCurrentblock()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:lightline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! LightlineTrailingSpaceWarning()
  if !exists("b:lightline_trailing_space_warning")

    if !&modifiable
      let b:lightline_trailing_space_warning = ''
      return b:lightline_trailing_space_warning
    endif

    if search('\s\+$', 'nw') != 0
      let b:lightline_trailing_space_warning = '[\s]'
      call lightline#update()
    else
      let b:lightline_trailing_space_warning = ''
    endif
  endif
  return b:lightline_trailing_space_warning
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:lightline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! LightlineTabWarning()
  if !exists("b:statusline_tab_warning")
    let b:lightline_tab_warning = ''

    if !&modifiable
      return b:lightline_tab_warning
    endif

    let tabs = search('^\t', 'nw') != 0

    "find spaces that arent used as alignment in the first indent column
    let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

    if tabs && spaces
      let b:lightline_tab_warning =  '[mix-indent]'
    elseif (spaces && !&et) || (tabs && &et)
      let b:lightline_tab_warning = '[&et]'
    endif
  endif
  return b:lightline_tab_warning
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
      \ 'main': 'CtrlPStatusFunc_1',
      \ 'prog': 'CtrlPStatusFunc_2',
      \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

augroup vimrc
  autocmd!
augroup END

" Intuitive backspacing
set backspace=indent,eol,start
" Adjust extra spaces between rows
set linespace=2
" Line numbers on
set nu
" Don't show matching brackets/parenthesis
set noshowmatch
" Match, to be used with %
set matchpairs+=<:>,[:]
" Bracket blinking
set matchtime=10
" Avoid loading matchparen plugin
let loaded_matchparen = 1
" Find as you type search
set incsearch
" Highlight search terms
set hlsearch
" Windows can be 0 line high
set winminheight=0
" Case insensitive search
set ignorecase
" Case sensitive when capital letter present
set smartcase
" Show list instead of just completing
set wildmenu
" Command <Tab> completion, list matches, then longest common part, then all
set wildmode=list:longest,full
" Backspace and cursor keys wrap too
set whichwrap=b,s,h,l,<,>,[,]
" Lines to scroll when cursor leaves screen
set scrolljump=1
" Minimum lines to keep above and below cursor
set scrolloff=2
" Display as much as possibe of a window's last line
set display+=lastline
" Turn off folding
set nofoldenable
" folds must be defined by entering commands (such as v{motion}zf)
set foldmethod=manual
" Don't autofold anything (but I can still fold manually)
set foldlevelstart=99
" Highlight problematic whitespace
set listchars=tab:›\ ,eol:¶,trail:•,extends:»,precedes:«,nbsp:.
" Display unprintable characters <C-h> - switches
set nolist

" }

" ############################################################################
" Formatting {
" ############################################################################

" Do not wrap long lines
set nowrap
" Indent at the same level of the previous line
set autoindent
" Use indents of 2 spaces
set shiftwidth=2
" Tabs are spaces, not tabs
set expandtab
" An indentation every four columns
set tabstop=2
" Let backspace delete indent
set softtabstop=2
" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces
" Puts new vsplit windows to the right of the current
set splitright
" Puts new split windows to the bottom of the current
set splitbelow
" pastetoggle (sane indentation on pastes)
set pastetoggle=<F12>
" auto format comment blocks
"set comments=sl:/*,mb:*,elx:*/
" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql
      \ autocmd BufWritePre <buffer> call StripTrailingWhitespace()
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

" ############################################################################
" Key (re)Mappings {
" ############################################################################

" ----------------------------------------------------------------------------
" The default leader is '\'
" ----------------------------------------------------------------------------
let mapleader      = ' '
let maplocalleader = ' '

" ----------------------------------------------------------------------------
" Wrapped lines goes down/up to next row, rather than next line in file.
" ----------------------------------------------------------------------------
noremap j gj
noremap k gk

" ----------------------------------------------------------------------------
" Easy resize window
" ----------------------------------------------------------------------------
" nnoremap <left>   <c-w>>
" nnoremap <right>  <c-w><
" nnoremap <up>     <c-w>-
" nnoremap <down>   <c-w>+

" ----------------------------------------------------------------------------
" End/Start of line motion keys act relative to row/wrap width in the
" presence of `:set wrap`, and relative to line for `:set nowrap`.
" Default vim behaviour is to act relative to text line in both cases
" Same for 0, home, end, etc
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Map g* keys in Normal, Operator-pending, and Visual+select
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Stupid shift key fixes
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Code folding options
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
"UPPERCASE and lowercase conversion
" ----------------------------------------------------------------------------
"nnoremap g^ gUiW
"nnoremap gv guiW

" ----------------------------------------------------------------------------
"go to first and last char of line
" ----------------------------------------------------------------------------
"nnoremap H ^
"nnoremap L g_
"vnoremap H ^
"vnoremap L g_

" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
nnoremap <silent> <C-k> :move-2<cr>
nnoremap <silent> <C-j> :move+<cr>
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>
xnoremap <silent> <C-k> :move-2<cr>gv
xnoremap <silent> <C-j> :move'>+<cr>gv
xnoremap <silent> <C-h> <gv
xnoremap <silent> <C-l> >gv
xnoremap < <gv
xnoremap > >gv

" ----------------------------------------------------------------------------
" Most prefer to toggle search highlighting rather than clear the current
" search results. To clear search highlighting rather than toggle it on
" and off, uncomment next line
" nmap <silent> <leader>/ :nohlsearch<CR>
" and comment the next one
" ----------------------------------------------------------------------------
nmap <silent> <leader>/ :set invhlsearch<CR>

" ----------------------------------------------------------------------------
" Find merge conflict markers
" ----------------------------------------------------------------------------
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" ----------------------------------------------------------------------------
" Shortcuts
" Change Working Directory to that of the current file
" ----------------------------------------------------------------------------
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" ----------------------------------------------------------------------------
" Visual shifting (does not exit Visual mode)
" ----------------------------------------------------------------------------
vnoremap < <gv
vnoremap > >gv

" ----------------------------------------------------------------------------
" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
" ----------------------------------------------------------------------------
vnoremap . :normal .<CR>

" ----------------------------------------------------------------------------
" Some helpers to edit mode
" http://vimcasts.org/e/14
" ----------------------------------------------------------------------------
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" ----------------------------------------------------------------------------
" Adjust viewports to the same size
" ----------------------------------------------------------------------------
map <Leader>= <C-w>=

" ----------------------------------------------------------------------------
" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
" ----------------------------------------------------------------------------
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" ----------------------------------------------------------------------------
" Easier horizontal scrolling
" ----------------------------------------------------------------------------
map zl zL
map zh zH

" ----------------------------------------------------------------------------
" Easier formatting
" ----------------------------------------------------------------------------
" nnoremap <silent> <leader>q gwip

" ----------------------------------------------------------------------------
" Show/Hide hidden Chars
" ----------------------------------------------------------------------------
map <silent> <C-h> :set invlist<CR>

" ----------------------------------------------------------------------------
" Save
" ----------------------------------------------------------------------------
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>

" ----------------------------------------------------------------------------
" Disable CTRL-A on tmux or on screen
" ----------------------------------------------------------------------------
if $TERM =~ 'screen'
  nnoremap <C-a> <nop>
  nnoremap <Leader><C-a> <C-a>
endif

" ----------------------------------------------------------------------------
" Quit
" ----------------------------------------------------------------------------
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" ----------------------------------------------------------------------------
" Tag stack
" ----------------------------------------------------------------------------
nnoremap g[ :pop<cr>

" ----------------------------------------------------------------------------
" Movement in insert mode
" ----------------------------------------------------------------------------
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" ----------------------------------------------------------------------------
" Zoom
" ----------------------------------------------------------------------------
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>

" ----------------------------------------------------------------------------
" Last inserted text
" ----------------------------------------------------------------------------
nnoremap g. :normal! `[v`]<cr><left>

" ----------------------------------------------------------------------------
" Quickfix
" ----------------------------------------------------------------------------
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" ----------------------------------------------------------------------------
" <tab> / <s-tab> / <c-v><tab> | super-duper-tab
" ----------------------------------------------------------------------------
function! s:can_complete(func, prefix)
  if empty(a:func)
    return 0
  endif
  let start = call(a:func, [1, ''])
  if start < 0
    return 0
  endif

  let oline  = getline('.')
  let line   = oline[0:start-1] . oline[col('.')-1:]

  let opos   = getpos('.')
  let pos    = copy(opos)
  let pos[2] = start + 1

  call setline('.', line)
  call setpos('.', pos)
  let result = call(a:func, [0, matchstr(a:prefix, '\k\+$')])
  call setline('.', oline)
  call setpos('.', opos)

  return !empty(type(result) == type([]) ? result : result.words)
endfunction

function! s:feedkeys(k)
  call feedkeys(a:k, 'n')
  return ''
endfunction

function! s:super_duper_tab(pumvisible, next)
  let [k, o] = a:next ? ["\<c-n>", "\<tab>"] : ["\<c-p>", "\<s-tab>"]
  if a:pumvisible
    return s:feedkeys(k)
  endif

  let line = getline('.')
  let col = col('.') - 2
  if line[col] !~ '\k\|[/~.]'
    return s:feedkeys(o)
  endif

  let prefix = expand(matchstr(line[0:col], '\S*$'))
  if prefix =~ '^[~/.]'
    return s:feedkeys("\<c-x>\<c-f>")
  endif
  if s:can_complete(&omnifunc, prefix)
    return s:feedkeys("\<c-x>\<c-o>")
  endif
  if s:can_complete(&completefunc, prefix)
    return s:feedkeys("\<c-x>\<c-u>")
  endif
  return s:feedkeys(k)
endfunction

if has_key(g:plugs, 'ultisnips')
  " UltiSnips will be loaded only when tab is first pressed in insert mode
  if !exists(':UltiSnipsEdit')
    inoremap <silent> <Plug>(tab) <c-r>=plug#load('ultisnips')?UltiSnips#ExpandSnippet():''<cr>
    imap <tab> <Plug>(tab)
  endif

  let g:SuperTabMappingForward  = "<tab>"
  let g:SuperTabMappingBackward = "<s-tab>"
  function! SuperTab(m)
    return s:super_duper_tab(a:m == 'n' ? "\<c-n>" : "\<c-p>",
                           \ a:m == 'n' ? "\<tab>" : "\<s-tab>")
  endfunction
else
  inoremap <silent> <tab>   <c-r>=<SID>super_duper_tab(pumvisible(), 1)<cr>
  inoremap <silent> <s-tab> <c-r>=<SID>super_duper_tab(pumvisible(), 0)<cr>
endif

" ----------------------------------------------------------------------------
" Markdown headings
" ----------------------------------------------------------------------------
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

" ----------------------------------------------------------------------------
" <Leader>c Close quickfix/location window
" ----------------------------------------------------------------------------
nnoremap <leader>c :cclose<bar>lclose<cr>

" ----------------------------------------------------------------------------
" #gi / #gpi | go to next/previous indentation level
" ----------------------------------------------------------------------------
function! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:go_indent(times, dir)
  for _ in range(a:times)
    let l = line('.')
    let x = line('$')
    let i = s:indent_len(getline(l))
    let e = empty(getline(l))

    while l >= 1 && l <= x
      let line = getline(l + a:dir)
      let l += a:dir
      if s:indent_len(line) != i || empty(line) != e
        break
      endif
    endwhile
    let l = min([max([1, l]), x])
    execute 'normal! '. l .'G^'
  endfor
endfunction
nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
nnoremap <silent> gpi :<c-u>call <SID>go_indent(v:count1, -1)<cr>

" ----------------------------------------------------------------------------
" <leader>bs | buf-search
" ----------------------------------------------------------------------------
nnoremap <leader>bs :cex []<BAR>bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>

" ----------------------------------------------------------------------------
" #!! | Shebang
" ----------------------------------------------------------------------------
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" }

" ############################################################################
" Plugins {
" ############################################################################

" ----------------------------------------------------------------------------
" EditorConfig Vim Plugin {
" ----------------------------------------------------------------------------
if isdirectory(expand("~/.vim/bundle/editorconfig-vim"))
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
endif
" }

" ----------------------------------------------------------------------------
" PIV {
" ----------------------------------------------------------------------------
if isdirectory(expand("~/.vim/bundle/PIV"))
  let g:DisableAutoPHPFolding = 1
  let g:PIVAutoClose = 0
endif
" }

" ----------------------------------------------------------------------------
" Qargs {
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Misc {
" ----------------------------------------------------------------------------
if isdirectory(expand("~/.vim/bundle/matchit.zip"))
  let b:match_ignorecase = 1
endif
" }

" ----------------------------------------------------------------------------
" Emmet {
" ----------------------------------------------------------------------------
let g:user_emmet_leader_key='<C-E>'
" }

" ----------------------------------------------------------------------------
" Ctags {
" ----------------------------------------------------------------------------
set tags=./tags;/,~/.vimtags

" ----------------------------------------------------------------------------
" Make tags placed in .git/tags file available in all levels of a repository
" ----------------------------------------------------------------------------
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
  let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" }

" ----------------------------------------------------------------------------
" AutoCloseTag {
" Make it so AutoCloseTag works for xml and xhtml files as well
" ----------------------------------------------------------------------------
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" ----------------------------------------------------------------------------
" EasyAlign {
" Start interactive EasyAlign in visual mode (e.g. vipga)
" ----------------------------------------------------------------------------
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }

" ----------------------------------------------------------------------------
" FZF {
" ----------------------------------------------------------------------------

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" File preview using Highlight (http://www.andre-simon.de/doku/highlight/en/highlight.php)
let g:fzf_files_options = printf('--preview "%s {} | head -'.&lines.'"',
      \ g:plugs['fzf.vim'].dir.'/bin/preview.rb')

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader><Enter>  :Buffers<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

command! Plugs call fzf#run({
  \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
  \ 'options': '--delimiter / --nth -1',
  \ 'down':    '~40%',
  \ 'sink':    'Explore'})

" Search includes hidden files (HFiles)
" TODO: need more work
" - choose right word for command.
if executable('ag')
  command! -bang -nargs=? -complete=dir HFiles
        \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)
endif
" }

" ----------------------------------------------------------------------------
" SnipMate {
" ----------------------------------------------------------------------------
" Setting the author var
let g:snips_author = 'Igor R. Plity <iryston@iryston.net>'
" }

" ----------------------------------------------------------------------------
" Startify {
" ----------------------------------------------------------------------------
let g:startify_bookmarks = [
      \ $HOME . "/.vimrc"
      \ ]
" Disable random quotes header
let g:startify_custom_header = []
let g:startify_enable_unsafe = 0
" Prevent CtrlP to open a split in Startify
let g:ctrlp_reuse_window = 'startify'
" }

" ----------------------------------------------------------------------------
" Syntastic {
" ----------------------------------------------------------------------------
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 2
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

if executable('eslint')
  let g:syntastic_javascript_checkers = ['eslint']
endif

if executable('vint')
  let g:syntastic_vim_checkers = ['vint']
endif

" run the php checker first, and if no errors are found, run phpcs, and then phpmd
let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']

"let g:syntastic_error_symbol = ''
"let g:syntastic_style_error_symbol = ''
"let g:syntastic_warning_symbol = ''
"let g:syntastic_style_warning_symbol = ''

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn
" }

" ----------------------------------------------------------------------------
" NerdTree {
" ----------------------------------------------------------------------------
if isdirectory(expand("~/.vim/bundle/nerdtree"))
  nnoremap <F9> :NERDTreeToggle<cr>

  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
          \  if isdirectory(expand('<amatch>'))
          \|   call plug#load('nerdtree')
          \|   execute 'autocmd! nerd_loader'
          \| endif
  augroup END

  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
  let NERDTreeChDirMode=0
  let NERDTreeQuitOnOpen=1
  let NERDTreeMouseMode=2
  let NERDTreeShowHidden=1
  let g:NERDShutUp=1
  let g:NERDTreeBookmarksFile = $HOME . '/.vim/local/.NERDTreeBookmarks'
endif
" }

" ----------------------------------------------------------------------------
" Tabularize {
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Session List {
" ----------------------------------------------------------------------------
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
  nmap <leader>sl :SessionList<CR>
  nmap <leader>ss :SessionSave<CR>
  nmap <leader>sc :SessionClose<CR>
endif
" }

" ----------------------------------------------------------------------------
" JSON {
" ----------------------------------------------------------------------------
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
let g:vim_json_syntax_conceal = 0
" }

" ----------------------------------------------------------------------------
" PyMode {
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" ctrlp {
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" TagBar {
" ----------------------------------------------------------------------------
if v:version >= 703
  if isdirectory(expand("~/.vim/bundle/tagbar/"))
    inoremap <F8> <esc>:TagbarToggle<cr>
    nnoremap <F8> :TagbarToggle<cr>
    let g:tagbar_sort = 0
  endif
endif
"}

" ----------------------------------------------------------------------------
" Fugitive {
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Normal Vim omni-completion {
" To disable omni complete, comment next lines:
" Enable omni-completion.
" ----------------------------------------------------------------------------
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" }

" ----------------------------------------------------------------------------
" FIXME: Isn't this for Syntastic to handle?
" Haskell post write lint and check with ghcmod
" $ `cabal install ghcmod` if missing and ensure
" ~/.cabal/bin is in your $PATH.
" ----------------------------------------------------------------------------
if !executable("ghcmod")
  autocmd BufWritePost *.hs GhcModCheckAndLintAsync
endif

" ----------------------------------------------------------------------------
" UndoTree {
" ----------------------------------------------------------------------------
if isdirectory(expand("~/.vim/bundle/undotree/"))
  nnoremap <Leader>u :UndotreeToggle<CR>
  " If undotree is opened, it is likely one wants to interact with it.
  let g:undotree_SetFocusWhenToggle=1
  let g:undotree_WindowLayout = 2
endif
" }

" ----------------------------------------------------------------------------
" indent_guides {
" ----------------------------------------------------------------------------
if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_enable_on_vim_startup = 1
endif
" }

" ----------------------------------------------------------------------------
" vim-commentary {
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
" }

" ----------------------------------------------------------------------------
" vim-slash {
" ----------------------------------------------------------------------------
function! s:blink(times, delay)
  let s:blink = { 'ticks': 2 * a:times, 'delay': a:delay }

  function! s:blink.tick(_)
    let self.ticks -= 1
    let active = self == s:blink && self.ticks > 0

    if !self.clear() && active && &hlsearch
      let [line, col] = [line('.'), col('.')]
      let w:blink_id = matchadd('IncSearch',
            \ printf('\%%%dl\%%>%dc\%%<%dc', line, max([0, col-2]), col+2))
    endif
    if active
      call timer_start(self.delay, self.tick)
    endif
  endfunction

  function! s:blink.clear()
    if exists('w:blink_id')
      call matchdelete(w:blink_id)
      unlet w:blink_id
      return 1
    endif
  endfunction

  call s:blink.clear()
  call s:blink.tick(0)
  return ''
endfunction

if has('timers')
  if has_key(g:plugs, 'vim-slash')
    noremap <expr> <plug>(slash-after) <sid>blink(2, 50)
  else
    noremap <expr> n 'n'.<sid>blink(2, 50)
    noremap <expr> N 'N'.<sid>blink(2, 50)
    cnoremap <expr> <cr> (stridx('/?', getcmdtype()) < 0 ? '' : <sid>blink(2, 50))."\<cr>"
  endif
endif
" }

" ----------------------------------------------------------------------------
" gv.vim {
" ----------------------------------------------------------------------------
function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>
" }

" ----------------------------------------------------------------------------
" splitjoin {
" ----------------------------------------------------------------------------
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
" }

" }

" ############################################################################
" GUI Settings {
" ############################################################################

" ----------------------------------------------------------------------------
" GVIM- (here instead of .gvimrc)
" ----------------------------------------------------------------------------
if has('gui_running')
" Remove the toolbar
  set guioptions-=T
" Remove the scrollbar
  set guioptions-=r
" Maximize window on start
  set lines=100 columns=200
  " set fu
  if LINUX() && has("gui_running")
    set guifont=Input\ Mono\ Regular\ 11,Cousine\ Regular\ 13,Monospace\ Regular\ 11,Ubuntu\ Mono\ Regular\ 13,Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
  elseif OSX() && has("gui_running")
    set guifont=Input\ Mono\ Regular:h14,Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
    " For MacVim
    set noimd
    set imi=1
    set ims=-1
    set fullscreen
  elseif WINDOWS() && has("gui_running")
    set guifont=Input_Mono:h10,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
  endif
  let g:gruvbox_contrast_dark="soft"
  let g:gruvbox_contrast_light="soft"
  set background=dark
  colorscheme gruvbox
else
  if &term == 'xterm' || &term == 'xterm-256color' || &term == 'screen'
    set t_Co=256 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    "let &t_SI = "\<Esc>]12;Blue\x7"
    "let &t_EI = "\<Esc>]12;NavyBlue\x7"
  endif
  if has("nvim")
    set termguicolors
  endif
  let g:gruvbox_contrast_dark="soft"
  let g:gruvbox_contrast_light="soft"
  set background=dark
  colorscheme gruvbox
endif

" Don't show the mode since statusline shows it
set noshowmode
" Set the title of the window in the terminal to the file
set title
" Resize windows as little as possible
set noequalalways

" ----------------------------------------------------------------------------
" Encoding menu {
" ----------------------------------------------------------------------------
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

" ############################################################################
" Functions {
" ############################################################################

" ----------------------------------------------------------------------------
" Quick open large files
" ----------------------------------------------------------------------------
let g:LargeFile = 1024 * 1024 * 50
augroup LargeFile
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) |
        \ if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function LargeFile()
  " no syntax highlighting etc
  set eventignore+=FileType
  " save memory when other file is viewed
  setlocal bufhidden=unload
  " is read-only (write with :w new_filename)
  setlocal buftype=nowrite
  " no undo possible
  setlocal undolevels=-1
  " display message
  autocmd VimEnter *  echo "The file is larger than "
        \ . (g:LargeFile / 1024 / 1024)
        \ . " MB, so some options are changed (see .vimrc for details)."
endfunction

" ----------------------------------------------------------------------------
" Initialize directories {
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Strip whitespace {
" ----------------------------------------------------------------------------
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

command! StripTrailingWhitespace call StripTrailingWhitespace()

command! StripLeadingWhitespace %le

" }

" ----------------------------------------------------------------------------
" Shell command {
" ----------------------------------------------------------------------------
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


" ----------------------------------------------------------------------------
" :Count
" ----------------------------------------------------------------------------
command! -nargs=1 Count execute printf('%%s/%s//gn', escape(<q-args>, '/')) | normal! ``

" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    execute 'lcd' root
    echo 'Changed directory to: '.root
  endif
endfunction
command! Root call s:root()

" ----------------------------------------------------------------------------
" <F8> | Color scheme selector
" ----------------------------------------------------------------------------
function! s:colors(...)
  return filter(map(filter(split(globpath(&rtp, 'colors/*.vim'), "\n"),
        \                  'v:val !~ "^/usr/"'),
        \           'fnamemodify(v:val, ":t:r")'),
        \       '!a:0 || stridx(v:val, a:1) >= 0')
endfunction

function! s:rotate_colors()
  if !exists('s:colors')
    let s:colors = s:colors()
  endif
  let name = remove(s:colors, 0)
  call add(s:colors, name)
  execute 'colorscheme' name
  redraw
  echo name
endfunction

nnoremap <silent> <F3> :call <SID>rotate_colors()<cr>

" ----------------------------------------------------------------------------
" SaveMacro / LoadMacro
" ----------------------------------------------------------------------------
function! s:save_macro(name, file)
  let content = eval('@'.a:name)
  if !empty(content)
    call writefile(split(content, "\n"), a:file)
    echom len(content) . " bytes save to ". a:file
  endif
endfunction
command! -nargs=* SaveMacro call <SID>save_macro(<f-args>)

function! s:load_macro(file, name)
  let data = join(readfile(a:file), "\n")
  call setreg(a:name, data, 'c')
  echom "Macro loaded to @". a:name
endfunction
command! -nargs=* LoadMacro call <SID>load_macro(<f-args>)

" ----------------------------------------------------------------------------
" HL | Find out syntax group
" ----------------------------------------------------------------------------
function! s:hl()
  " echo synIDattr(synID(line('.'), col('.'), 0), 'name')
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), '/')
endfunction
command! HL call <SID>hl()

" ----------------------------------------------------------------------------
" TX
" ----------------------------------------------------------------------------
command! -nargs=1 TX
  \ call system('tmux split-window -d -l 16 '.<q-args>)
cnoremap !! TX<space>

" ----------------------------------------------------------------------------
" co? : Toggle options
" ----------------------------------------------------------------------------
function! s:map_change_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<cr>", key, op, opt)
endfunction

call s:map_change_option('p', 'paste')
call s:map_change_option('n', 'number')
call s:map_change_option('w', 'wrap')
call s:map_change_option('h', 'hlsearch')
call s:map_change_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:map_change_option('b', 'background',
    \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')

" }

" ============================================================================
" AUTOCMD {
" ============================================================================

augroup vimrc

  " File types
  au BufNewFile,BufRead *.icc               set filetype=cpp
  au BufNewFile,BufRead *.pde               set filetype=java
  au BufNewFile,BufRead *.coffee-processing set filetype=coffee
  au BufNewFile,BufRead Dockerfile*         set filetype=dockerfile

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

  " Close preview window
  if exists('##CompleteDone')
    au CompleteDone * pclose
  else
    au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif
  endif

  " Automatic rename of tmux window
  if exists('$TMUX') && !exists('$NORENAME')
    au BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    au VimLeave * call system('tmux set-window automatic-rename on')
  endif
augroup END

" ----------------------------------------------------------------------------
" Help in new tabs
" ----------------------------------------------------------------------------
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
autocmd vimrc BufEnter *.txt call s:helptab()

" }
