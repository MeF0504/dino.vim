" Name:         dino.vim
" Description:  vim plugin like chrome://dino
" Author:       MeF

if exists('g:loaded_dino')
    finish
endif
let g:loaded_dino = 1

command! Dino call dino#run_dino()

