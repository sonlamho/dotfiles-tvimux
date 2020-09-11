"""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")
"
"""""""""""""""""""""""""""""""""""""""""""""""
" Set separate dirs for backup, swap, and undo files
let &directory = expand('~/.vimdata/swap//')

set backup
let &backupdir = expand('~/.vimdata/backup//')

set undofile
let &undodir = expand('~/.vimdata/undo//')

if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif
if !isdirectory(&directory) | call mkdir(&directory, "p") | endif

" Editor settings
" set autoread
syntax on
set scrolloff=10      "default=5 makes cursor too close to edges
set expandtab         "Use 2 spaces for tabs
set shiftwidth=2
set softtabstop=2
set tabstop=2
set ruler
set number
set relativenumber    "Very slow on ruby files for some reason
set re=1              "Use the old regex engine which is faster ...
set ignorecase
set smartcase
set wrap
set textwidth=0
set formatoptions-=t  " No auto line breaks
set background=dark
" if has('termguicolors')
"   hi Normal guibg=NONE ctermbg=NONE
" endif

" visual mode indenting made easier
vnoremap < <gv
vnoremap > >gv

" Ctrl-N to create new empty tab
nnoremap <C-n> :tabnew<CR>

" Ignore python's 4-space indent guideline
let g:python_recommended_style = 0
filetype plugin indent on
" Don't use relnumbering for ruby files
" autocmd FileType ruby setlocal ts=2 sts=2 sw=2 norelativenumber nocursorline
autocmd FileType ruby setlocal ts=2 sts=2 sw=2 nocursorline

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Ctrl-s to save file
nnoremap <C-s> :update<CR>

" Switch panes and tabs better
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap gb :tabprevious<CR>


command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []
  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor
  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

function! SaveSessionAndQuit()
  let l:tmpdir = getcwd() . '/tmp'
  if !isdirectory(l:tmpdir) | call mkdir(l:tmpdir, "p") | endif
  " Save at path/to/project/tmp/_session.vim
  let l:com = 'mksession! ' . l:tmpdir . '/_session.vim'
  echom l:com
  execute l:com
  qall
endfunction

" set <Leader>
let mapleader = " "

" Scrolling
nnoremap <Leader>j 30<C-e>
nnoremap <Leader>k 30<C-y>

" Quick open location list
nnoremap <Leader>l :lopen<CR>

" Quick open vimrc to edit
nnoremap <Leader>vrc :tabnew<CR>:e ~/.vimrc<CR>:vsplit<CR>:e ~/.vimrc.plug<CR>:vsplit<CR>:e ~/.config/alacritty/alacritty.yml<CR>

" Quick session save and closing
nnoremap <Leader>x :CloseHiddenBuffers<CR>:call SaveSessionAndQuit()<CR>
nnoremap <Leader>qa :tabclose<CR>

" Call the .vimrc.plug file
" See here to install Vim-Plug: https://github.com/junegunn/vim-plug
if filereadable(expand("~/.vimrc.plug"))
  source ~/.vimrc.plug

  " SETTINGS FOR PLUGINS:
  nnoremap <C-s> :update<CR>:GitGutterAll<CR>
  let g:indentLine_char = '▏'
  colorscheme delek
  let g:airline_theme='bubblegum'
  let g:airline#extensions#tabline#enabled = 1

  " python syntax
  let g:python_highlight_string_formatting = 1
  let g:python_highlight_string_format = 1
  let g:python_highlight_string_templates = 1
  let g:python_highlight_class_vars = 1
  let g:python_highlight_builtins = 1
  let g:python_highlight_all = 0
  " let g:python_highlight_exceptions = 1

  nnoremap <Leader>\ :NERDTreeToggle<CR>

  " Use ag instead of ack if available
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

  " FZF
  nnoremap <C-p> :GFiles<CR>

  " YCM
  " Do `rustup component add rls rust-analysis rust-src` to make rust completion work
  let g:ycm_clangd_binary_path = '/usr/bin/clangd'
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  " let g:ycm_min_num_identifier_candidate_chars = 1
  nnoremap <C-@> :YcmCompleter GetDoc<CR>
  nnoremap <C-space> :YcmCompleter GetDoc<CR>
  nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
  nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>

  " ALE
  nnoremap <Leader>[ :ALEPreviousWrap<CR>
  nnoremap <Leader>] :ALENextWrap<CR>
  nnoremap <Leader><F7> :ALEToggleBuffer<CR>
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  let g:ale_linters_explicit = 0
  let g:ale_linters = {
  \ 'python': ['mypy','flake8'],
  \ 'ruby': ['rubocop', 'ruby'],
  \ 'rust': ['cargo'],
  \ }
  highlight ALEWarning ctermbg=black

else
  colorscheme delek
endif

set colorcolumn=80    " A line at column 80
highlight ColorColumn ctermbg=0 guibg=lightgrey
hi VertSplit guibg=lightgrey guifg=lightgrey ctermbg=0 ctermfg=0
hi MatchParen cterm=underline ctermbg=0 ctermfg=white
