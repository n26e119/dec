syntax on
filetype on
filetype plugin on
hi Pmenu ctermfg=black ctermbg=gray guibg=#444444
hi PmenuSel ctermfg=7 ctermbg=4 guibg=#555555 guifg=#ffffff

set background=dark
set number
set showmode
set showcmd
set noswapfile
set nobackup
set nocompatible
set noerrorbells
set wrap
set vb t_vb=
set ignorecase
set mouse-=a
set scrolloff=7
set fileencodings=utf-8,gb18030,ucs-bom,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileformat=unix
set noexpandtab
set tabstop=8
set softtabstop=8
set shiftwidth=8
set shiftround
set smartindent
set backspace=indent,eol,start
set statusline+=%f
set laststatus=2
set makeprg=mmake

" set mapping
inoremap jj <Esc>

call plug#begin('~/.vim/plugged')

" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/async.vim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" vim-rooter
Plug 'airblade/vim-rooter'

" git
Plug 'tpope/vim-fugitive'

call plug#end()

" lsp configuration
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" install llvm first
if executable('clangd')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'clangd',
		\ 'cmd': {server_info->['clangd', '-background-index']},
		\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
	\ })
endif

" go install golang.org/x/tools/gopls@latest
if executable('gopls')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'gopls',
		\ 'cmd': {server_info->['gopls', '-remote=auto']},
		\ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl'],
	\ })

	autocmd BufWritePre *.go
		\ call execute('LspDocumentFormatSync') |
		\ call execute('LspCodeActionSync source.organizeImports')
endif

" pip install python-lsp-server
if executable('pylsp')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'pylsp',
		\ 'cmd': {server_info->['pylsp']},
		\ 'whitelist': ['python'],
	\ })
endif

" rustup update
" rustup component add rust-analyzer
if executable('rustup')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'rust-analyzer',
    		\ 'cmd': {server_info->['rustup', 'run', 'stable', 'rust-analyzer']},
    		\ 'allowlist': ['rust'],
    	\ })
endif

let g:lsp_signature_help_enabled = 0

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	" setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gD <plug>(lsp-peek-definition)
	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> [g <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)
	nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-k> lsp#scroll(-4)

	let g:lsp_format_sync_timeout = 1000
	autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

	" refer to doc to add more commands
endfunction

augroup lsp_install
	au!
	" call s:on_lsp_buffer_enabled only for languages that has the server registered.
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" fzf configuration
let g:fzf_vim = {}

" vim-rooter
let g:rooter_targets = '/,*'
let g:rooter_patterns = ['.git']

