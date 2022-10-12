source ~/.gvimrc
set makeprg=make
set shiftwidth=3
"map <F1> :make -f $ADA_DIR/ada_ide_env.makefile find_decl SYMBOL=<C-R>=expand("<cword>")<CR><CR>:copen<CR>
map <F1> :make -f $ADA_DIR/ada_ide_env.makefile find_decl SYMBOL=<C-R>=expand("<cword>")<CR><CR>
"map <S-F1> :make -f $ADA_DIR/ada_ide_env.makefile find_body SYMBOL=<C-R>=expand("<cword>")<CR><CR>:copen<CR>
map <S-F1> :make -f $ADA_DIR/ada_ide_env.makefile find_body SYMBOL=<C-R>=expand("<cword>")<CR><CR>
map <F2> :make -f $ADA_DIR/ada_ide_env.makefile find_refs SYMBOL=<C-R>=expand("<cword>")<CR><CR>:copen<CR>
map <S-F2> :Ggrep <C-R>=expand("<cword>")<CR><CR>
map <F3> :make -f $ADA_DIR/ada_ide_env.makefile find_callers SYMBOL=<C-R>=expand("<cword>")<CR><CR>:copen<CR>
map <S-F3> :make -f $ADA_DIR/ada_ide_env.makefile find_calls SYMBOL=<C-R>=expand("<cword>")<CR><CR>:copen<CR>
map <F10> :wa<CR>:make -f $ADA_DIR/ada_ide_env.makefile build<CR>:copen<CR>
map <S-F10> :wa<CR>:make -f $ADA_DIR/ada_ide_env.makefile rebuild<CR>:copen<CR>

