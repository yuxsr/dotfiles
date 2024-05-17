call plug#begin()
Plug 'sainnhe/everforest'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'
call plug#end()

"" theme
" Important!!
if has('termguicolors')
	set termguicolors
endif

" For dark version.
set background=dark

" Set contrast.
" This configuration option should be placed before `colorscheme everforest`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'medium'

" For better performance
let g:everforest_better_performance = 1

colorscheme everforest

" vim-tmux-clipboard
let g:vim_tmux_clipboard#loadb_option = '-w'

