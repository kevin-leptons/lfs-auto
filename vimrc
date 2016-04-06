set cc=81
"set number
set hlsearch
highlight ColorColumn ctermbg=6
set tabstop=3
set shiftwidth=3
set expandtab
set ignorecase

if expand('%:t') =~? 'rfc3501.txt'
   setfiletype rfc
endif 


set nocompatible | filetype indent plugin on | syn on
