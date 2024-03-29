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
  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80
  autocmd FileType markdown setlocal textwidth=80
  augroup END

  augroup ZCPT
  au!
  au BufReadPre  *.zcpt setl bin viminfo= noswapfile nobackup noundofile
  au BufReadPost *.zcpt let $CPT_PASS = inputsecret("Password: ")
  au BufReadPost *.zcpt silent 1,$!ccrypt -cb -E CPT_PASS | gzip -cd
  au BufReadPost *.zcpt set nobin
  au BufWritePre *.zcpt set bin
  au BufWritePre *.zcpt silent! 1,$!gzip -c | ccrypt -e -E CPT_PASS
  au BufWritePost *.zcpt silent! u
  au BufWritePost *.zcpt set nobin
  augroup END

  augroup CPT
  au!
  au BufReadPre  *.cpt setl bin viminfo= noswapfile nobackup noundofile
  au BufReadPost *.cpt let $CPT_PASS = inputsecret("Password: ")
  au BufReadPost *.cpt silent 1,$!ccrypt -cb -E CPT_PASS
  au BufReadPost *.cpt set nobin
  au BufWritePre *.cpt set bin
  au BufWritePre *.cpt silent! 1,$!ccrypt -e -E CPT_PASS
  au BufWritePost *.cpt silent! u
  au BufWritePost *.cpt set nobin
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
filetype plugin indent on
set updatetime=3000
set scrolloff=10      "default=5 makes cursor too close to edges
set expandtab         "Use 2 spaces for tabs
set shiftwidth=2
set softtabstop=2
set tabstop=2
set ruler
set number
" set relativenumber
set cursorline
set re=1              "Use the old regex engine which is faster ...
set ignorecase
set background=dark
set colorcolumn=88    " A line at column 88
set smartcase
set nowrap
set textwidth=0
set formatoptions-=t  " No auto line breaks
" if has('termguicolors')
"   hi Normal guibg=NONE ctermbg=NONE
" endif

" visual mode indenting made easier
vnoremap < <gv
vnoremap > >gv

" Ctrl-N to create new empty tab
nnoremap <C-n> :tabnew<CR>

" Set below to 0 to ignore python's 4-space indent guideline
let g:python_recommended_style = 1
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
autocmd FileType julia setlocal ts=4 sts=4 sw=4

"Remove all trailing whitespace by pressing F5
" nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
nnoremap <F5> :ALEFix<CR>:update<CR>
inoremap <F5> <Esc>:ALEFix<CR>:update<CR>

" Ctrl-s to save file
nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>

" Switch panes and tabs better
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap gb :tabprevious<CR>

" in normal mode, Esc will close preview window
nnoremap <Esc> :pclose<CR>


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

function! SetCustomDelek()
  colorscheme delek
  hi ColorColumn ctermbg=black guibg=darkgrey
  hi CursorLine cterm=None ctermbg=black guibg=darkgrey
  hi Comment cterm=italic,bold ctermfg=darkgrey
  hi LineNr ctermfg=darkgrey
  hi VertSplit guibg=bg guifg=bg ctermbg=black ctermfg=darkgrey
  hi MatchParen cterm=bold,italic,underline ctermbg=black ctermfg=yellow
  hi Number ctermfg=magenta guifg=magenta
  hi String ctermfg=2 guifg=green3
  hi Function cterm=italic ctermfg=6 guifg=cyan4

  hi pythonFunctionCall ctermfg=6 guifg=cyan4
  hi pythonClass ctermfg=12 guifg=blue
  hi pythonStatement cterm=bold ctermfg=5 guifg=magenta3
  hi link pythonClassVar Structure
  hi link pythonNone Number
  hi link pythonBoolean Number
  hi link pythonFunctionCall Identifier

  hi Pmenu ctermfg=white ctermbg=black guibg=LightBlue
  hi PmenuSel ctermfg=white ctermbg=darkblue guifg=White guibg=DarkBlue
  hi PmenuSbar ctermbg=darkgrey guibg=DarkGrey
endfunction

function! SetSlimeKeys()
  let g:slime_no_mappings	= 1
  nmap <localleader>es <Plug>SlimeSendCell
  nmap <localleader>er <Plug>SlimeParagraphSend
  nmap <localleader>ee <Plug>SlimeLineSend
  xmap <localleader>E <Plug>SlimeRegionSend
  nmap <localleader>E <Plug>SlimeMotionSend
  nmap <localleader>ew viw<localleader>E
  nmap <localleader>eb ggVG<localleader>E<C-o>
endfunction

function! SetREPLKeys()
  " Olical Conjure settings
  let g:conjure#filetypes = ["clojure", "fennel", "janet", "racket", "scheme"]

  " Slime settings: mapped to match with Olical Conjure's default
  let g:slime_target = "neovim"
  let g:slime_python_ipython = 1
  let g:slime_cell_delimiter = "##"
  autocmd FileType * if index(g:conjure#filetypes, &ft) < 0 | call SetSlimeKeys() | endif
endfunction

function! SetupYCMKeys()
  nnoremap <C-space> :YcmCompleter GetDoc<CR>
  inoremap <C-space> <Esc>:YcmCompleter GetDoc<CR>a
  nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
  nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>
  nnoremap <Leader>t :YcmCompleter GetType<CR>
endfunction

function! SetupFireplaceKeys()
  nmap <Leader>gd <Plug>FireplaceDjump
  nmap <C-space> K
endfunction

function! SetGdGrKeys()
  let g:ycm_filetypes = ["python", "rust", "typescript", "javascript", "c", "cpp"]
  let g:fireplace_filetypes = ["clojure"]
  autocmd FileType * if index(g:ycm_filetypes, &ft) >= 0 | call SetupYCMKeys() | endif
  autocmd FileType * if index(g:fireplace_filetypes, &ft) >= 0 | call SetupFireplaceKeys() | endif
endfunction

" set <Leader>
let mapleader = " "
let maplocalleader = "\\"

" nav buffers
nnoremap <Leader><PageUp> :bprevious<CR>
nnoremap <Leader><PageDown> :bnext<CR>

" Quick open location list
nnoremap <Leader>l :lopen<CR>

" Quick open vimrc to edit
nnoremap <Leader>vrc :tabnew<Bar>:e ~/dotfiles/.vimrc<Bar>:vsplit<Bar>:e ~/dotfiles/.vimrc.plug<Bar>:vsplit<Bar>:e ~/.config/alacritty/alacritty.yml<CR>

" Quick session save and closing
nnoremap <Leader>x :tabdo NERDTreeClose<CR>:CloseHiddenBuffers<CR>:tabfirst<CR>:call SaveSessionAndQuit()<CR>
nnoremap <Leader>qa :tabclose<CR>

" Call the .vimrc.plug file
" See here to install Vim-Plug: https://github.com/junegunn/vim-plug
if filereadable(expand("~/.vimrc.plug"))
  source ~/.vimrc.plug

  " SETTINGS FOR PLUGINS:
  let g:airline_theme='bubblegum'
  nnoremap <C-s> :update<Bar>:GitGutterAll<CR>
  let g:indentLine_char = '▏'
  let g:airline#extensions#tabline#enabled = 1
  let g:rooter_silent_chdir = 1

  " python syntax highlighting
  let g:python_highlight_all = 1

  nnoremap <Leader>\ :NERDTreeToggle<CR>:NERDTreeRefreshRoot<CR><C-w>=
  let g:NERDTreeShowHidden=1

  " Use ag instead of ack if available
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif

  " FZF
  nnoremap <C-p> :GFiles<CR>

  " Deoplete
  " not completing for python since we have YCM for that
	autocmd FileType python
	\ call deoplete#custom#buffer_option('auto_complete', v:false)
  call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})

  " Pear-tree
  let g:pear_tree_repeatable_expand = 0
  let g:pear_tree_pairs = {
            \ '(': {'closer': ')'},
            \ '[': {'closer': ']'},
            \ '{': {'closer': '}'},
            \ "'": {'closer': ""},
            \ '"': {'closer': '"'}
            \ }
  let g:pear_tree_smart_openers = 1
  let g:pear_tree_smart_closers = 1
  let g:pear_tree_smart_backspace = 1

  " YCM
  " Do `rustup component add rls rust-analysis rust-src` to make rust completion work
  let g:ycm_filetype_whitelist = {'python': 1, 'rust': 1, 'javascript': 1, 'typescript': 1}
  let g:ycm_global_ycm_extra_conf = '~/.config/nvim/global_extra_conf.py'
  let g:ycm_clangd_binary_path = '/usr/bin/clangd'
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 0
  " let g:ycm_min_num_identifier_candidate_chars = 1

  " ALE : for linting and autoformatting
  nnoremap <Leader>[ :ALEPreviousWrap<CR>
  nnoremap <Leader>] :ALENextWrap<CR>
  nnoremap <Leader><F7> :ALEToggleBuffer<CR>
  let g:ale_echo_msg_format = '[%linter%][%code%] %s [%severity%]'
  let g:ale_linters_explicit = 0
  let g:ale_linters = {
  \ 'python': ['mypy','flake8'],
  \ 'ruby': ['rubocop', 'ruby'],
  \ 'rust': ['cargo'],
  \ 'clojure': ['clj-kondo'],
  \ }
  let g:ale_fixers = {
  \   '*': ['trim_whitespace', 'remove_trailing_lines'],
  \   'javascript': ['eslint'],
  \   'python': ['black'],
  \   'rust': ['rustfmt'],
  \}


  ""---- REPL : Conjure or Slime -------
  call SetREPLKeys()
  ""------------------------------------

  ""---- GetDoc/GotoDef/GetType etc ----
  call SetGdGrKeys()
  ""------------------------------------


  " colorscheme and modifications:
  call SetCustomDelek()
  highlight ALEWarning ctermbg=8 cterm=underline
  hi link YcmWarningSection ALEWarning
else
  colorscheme delek
endif

" Set some global highlighting options
hi diffAdded ctermfg=green
hi diffRemoved ctermfg=darkred
