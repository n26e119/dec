syntax on
filetype on
filetype plugin on
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

" set mapping
inoremap jj <Esc>

" vim plug
call plug#begin('~/.vim/plugged')

Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

" lsp
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
" inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"

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

" pip install python-language-server
if executable('pyls')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'pyls',
				\ 'cmd': {server_info->['pyls']},
				\ 'whitelist': ['python'],
				\ })
endif


let g:lsp_signature_help_enabled = 0

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	" setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> [g <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)
	nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

	let g:lsp_format_sync_timeout = 1000
	autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

	" refer to doc to add more commands
endfunction

augroup lsp_install
	au!
	" call s:on_lsp_buffer_enabled only for languages that has the server registered.
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
