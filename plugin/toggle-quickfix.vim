" Quickfix window toggle: {{{
"
" Usage: In normal mode, run <leader>qf
"
" @ref <Learn Vimscript the hard way>
"
" }}}

nnoremap <silent> <leader>qf :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute s:quickfix_return_to_window . "wincmd w"
    else
        let s:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
