"##### Environment #####
"#
"# Settings related to the editor environment
"#
"#######################

source $HOME/.vim/functions/our_functions.vim " Activate functions

set nocompatible                        " Use vim settings vs vi settings

"set colorcolumn=80                      " Set color of column 80
set diffopt+=iwhite,foldcolumn:0        " Ignore whitespace, foldcolumn:0 to set foldcolumn in vimdiff
set directory=$HOME/.vim/backup//       " Location for .swp files, trailing slashes store paths
"set clipboard=unnamed                   " Permit easy paste into windows apps
set encoding=utf-8                      " Use unicode
set foldmethod=marker                   " Markers are used to specify folds
set foldopen-=search                    " Do not open folds when searching
set foldopen-=undo                      " Do not open folds when undo'ing changes
set foldmarker={{{,}}}                  " Keep foldmarkers default
set foldcolumn=0                        " Don't waste space
set history=500                         " Number of lines of command-line history to keep. Default 20.
set hlsearch                            " Highlight matching search patterns
set laststatus=2                        " Display status line even on last window.
set list                                " Make tabs and trailing spaces visible
set listchars=tab:»·,trail:·            " The characters for tab and trailing spaces
set modeline                            " Read vim settings from modelines, eg  " vim: set ai tw=75:
set mouse-=a                            " Disable mouse
set nonumber                            " Do not show line numbers by default
set numberwidth=3                       " Set width of line number gutter
set popt=header:0                       " Do not print a header (:hardcopy). See popt-options.
set ruler                               " Show row and column in status bar
set selection=inclusive                 " Sets selection behaviour. See help for options.
set shellcmdflag=-lc                    " This permits user env aliases to be usable in shell commands
set shortmess=atI                       " Abbreviate messages. See :help shortmess
"set shortmess+=I                        " Abbreviate messages. See :help shortmess
set showcmd                             " Show command in status bar
set statusline=%-3.3n\ %F\ %r%#Error#%m%#Statusline#\ (%l/%L,\ %c)\ %P%=%h%w\ h%{&hlsearch}/p%{&paste}/s%{&spell}/t%{&tw}\ %y\ [%{&encoding}:%{&fileformat}]
set termencoding=utf-8                  " Use unicode for the terminal
set timeoutlen=500                      " Time to wait for leader (0.5 seconds)
set ttimeoutlen=100                     " Double time to wait for keycode
set ttyfast                             " Improves performance of pastes in xterm, screen, urxvt
set visualbell                          " Use visual bell instead of beeping
set wildmenu                            " Enhanced command line completion
set wildmode=list:longest               " Sets command line completion like bash
set nowritebackup                       " Backup before overwriting a file. Backup is removed after successful save.


"##### Editing #####
"#
"# Settings related to general editing.
"#
"#######################
set autoindent                          " On CR, indent if previous line was indented
set backspace=indent,eol,start          " Make backspaces delete sensibly
set comments=b:#,b:##,:%,n:>,fb:-,fb:*  " Defaults s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
set expandtab                           " Convert tabs to spaces
set incsearch                           " Incremental search
set linebreak                           " When wrapping, break on whitespace
set matchpairs+=<:>                     " Allow % to bounce between angles too
set shiftwidth=4                        " Set the indent width
set nojoinspaces                        " Insert only one space between sentences on join.
set nosmartindent                       " If smartindent is on shift right ">" does not move lines starting with '#'
set scrolloff=1                         " Minimum lines between cursor and top/bottom of screen
set smarttab                            " Tab shiftwidth at beginning of line
set softtabstop=4                       " See help
set tabstop=4                           " Convert each tab to 4 spaces
set wrap                                " Wrap long lines.

set ignorecase
set smartcase



"##### Autocmd #####
"#
"# Autocmd settings.
"#
"#######################
" Remove all auto-commands. Prevents commands being duplicated if
" .vimrc is sourced twice.
autocmd!

" Close the quickfix window if it is the last
autocmd BufEnter * call MyLastWindow()

autocmd BufRead /tmp/dm_steve/*         set ft=dm spell
autocmd BufRead /tmp/dm_test/*          set ft=dm spell
autocmd BufRead $HOME/doc/*             set ft=dm
autocmd BufRead $HOME/doc/sp            set ft=dm syntax=
autocmd BufRead /var/git/dm/steve/archive/*/notes   set ft=dm
autocmd BufRead *.md                    set ft=markdown spell

" Backup file prior to write with git
autocmd BufWritePre  * silent ! $HOME/bin/vim_git_backup.sh "%:p" $HOME/.vim/backup
autocmd BufWritePost * silent ! $HOME/bin/vim_git_backup.sh "%:p" $HOME/.vim/backup

autocmd BufWrite * call ConvertTabToSpace()
autocmd BufWrite * call RemoveTrailingWhitespace()
autocmd BufWrite *.snippets  :%s/    /\t/g      " snippets files require tabs
autocmd BufWrite cookies.txt :%s/    /\t/g      " cookie files require tabs

autocmd FileType python compiler pylint

filetype on                             " Detect filetype and trigger FileType event
"filetype indent on                      " Load indent file associated with detected filetype
filetype plugin on                      " Load plugin file associated with detected filetype


"##### Colours #####
"#
"# Settings related to syntax and colours
"#
"#######################
syntax enable                           " Runs :source $VIMRUNTIME/syntax/syntax.vim
"set synmaxcol=120                       " Prevents lag caused by syntax hl on long lines.

set t_Co=256                            " Number of colours
colorscheme steve
set cursorline                          " Highlight the line the cursor is on
autocmd InsertEnter * set nocursorline
autocmd InsertLeave * set cursorline


"##### Abbreviations #####
"#
"# Abbreviation settings and custom commands
"#
"#######################

":Help opens help in new tab
command! -nargs=* -complete=help Help tab :help <args>

":T opens new tab for edit
command! -nargs=* -complete=file T 0tabe <args>

":Tex convert to open in first tab
command! -nargs=* -complete=file Tex 0tabe | Exp

":W execute write, in case I fat finger :w
command! W :write


"##### Mappings #####
"#
"# Keyboard shortcut mappings
"#
"# NOTE: The pipe character signals the end of the map
"#       and the beginning of the comment.
"#
"#######################

let mapleader='\'

" Option toggle function
function MapToggle(key, opt)
    let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
    exec 'nnoremap '.a:key.' '.cmd
    exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

" And the commands to toggle
MapToggle <Leader>h hlsearch
MapToggle <Leader>i invnumber
MapToggle <Leader>p paste
MapToggle <Leader>s spell
MapToggle <Leader>w wrap

inoremap <silent> <Leader># <C-R>=DividerWithDateI()<CR>|
nmap <Leader># :call DividerWithDate()<CR>|             " Insert divider
map <Leader>[ /\[\(\/\\| \\|\.\\|\\\)\]<CR>l|           " Find next checkbox and centre
map <Leader>a ggVG|                                     " Select all
map <Leader>d <ESC>:call TimeStampInsert()<CR> |        " Insert date
map <Leader>o :tabedit |                                " Open new tab
map <Leader>r :call ReloadSnippets(snippets_dir, &filetype)<CR>| " Reload snippets without restarting vim
map <Leader>v "+P|                                      " Paste clipboard
map <Leader>x <ESC>:call XDMModIdInsert()<CR>|          " Insert X-DM-Mod-Id header

imap <C-t>     <C-R>=EmailGet()<CR>|                    " Get email address from gcontacts.

vmap <tab> >gv|                                         " Make tab in v mode ident code
vmap <s-tab> <gv|                                       " Unindent with Shift-tab
vmap <Leader>c "+y                                      " Copy to clipboard.
vmap <Leader>s <Plug>Vsurround|                         " s means surround with tag
vmap <Leader>S <Plug>VSurround|                         " S same as s except tags are on new lines

nmap <tab> i<tab><Right><ESC>|                          " Make tab in normal mode ident code
nmap <s-tab> v<I|                                       " Backspace with Shift-tab
nmap <Leader>cf :let @*=expand("%:p")<CR>|              " Copy filename and path to clipboard

nnoremap <silent> _t :%!perltidy -q<Enter>|             " Run perltidy on entire file with _t
vnoremap <silent> _t :!perltidy -q<Enter>|              " Run perltidy on selected lines with _t

inoremap <Leader>p <ESC>u:set paste<CR>.:set nopaste<CR>gi| " Undo paste with messed indents and repeat with paste set properly.

map Q       :q!|                                        " Do not use Q for Ex mode
map Y       y$|                                         " Yank from cursor to EOL
map <C-j>   gjzz|                                       " Scroll down
map <C-k>   gkzz|                                       " Scroll up
noremap j   gj|                                         " Line-by-line regardless of wrapping
noremap k   gk|                                         " Line-by-line regardless of wrapping
noremap K   <Nop>|                                      " Unbind 'K'
noremap <silent> <C-l> :nohls<CR><C-l>|                 " Add nohls to C-l
nnoremap <space> za|                                    " Space to open/close folds
nmap <Leader>q  gqap|                                   " Reformat current paragraph
map! <Leader>q  <ESC>gqapi|                             " Reformat current paragraph

" Popup menu key bindings
inoremap <silent>j <C-R>=PopupMenuControl('j')<CR>
inoremap <silent>k <C-R>=PopupMenuControl('k')<CR>

" normal tab behavior if no snippet is matched
if !exists("g:snipMate")
  let g:snipMate = {}
endif
let g:snipMate['no_match_completion_feedkeys_chars'] = "\<tab>"

call pathogen#infect()

function Sprunge() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\r")).'| curl -sF "sprunge=<-" http://sprunge.us | tr -d "\n" | xclip')
endfunction
com -range=% -nargs=0 Sprunge :<line1>,<line2>call Sprunge()
