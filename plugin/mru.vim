" Most Recently Opened Files: {{{
"
" Usage: In normal mode, run <leader>r, will show most 10 recently opened
" files; press o to edit the selected file
"
" @ref https://zhuanlan.zhihu.com/p/47374698
"
" }}}

" save g:MRU_FILES to ~/.viminfo
set viminfo+=!

if filereadable('~/.viminfo')
    rv
endif

if !exists('g:MRU_FILES')
    let g:MRU_FILES = []
endif

nnoremap <silent> <leader>r :call <SID>Mru()<cr>

let g:MRU_FILES = []
let g:mru_files_len = 10
let g:mru_buffer_is_open = 0

function s:Mru()
    if g:mru_buffer_is_open
        let s:mru_buffer_number = bufwinnr('__MRU_BUFFER__')
        execute s:mru_buffer_number . "bdelete"
        let g:mru_buffer_is_open = 0
    else
        call s:MruWindow()
        let g:mru_buffer_is_open = 1
        "let s:active_window = winnr()
    endif
endfunction

function s:MruAdd(path)
    "if len(a:path) ==# 0
        "return
    "endif
    let s:buf_type = getbufvar(bufnr(a:path), '&buftype', 'ERROR')
    if s:buf_type ==# 'nofile'
        return
    endif

    let idx = index(g:MRU_FILES, a:path)
    if idx >= 0
        call remove(g:MRU_FILES, idx)
    endif
    call insert(g:MRU_FILES, a:path)
    let g:MRU_FILES = g:MRU_FILES[:g:mru_files_len-1]
endfunction

autocmd BufWinLeave,BufWritePost * call s:MruAdd(expand('%:p'))

function s:MruWindow()
    let rows = len(g:MRU_FILES)
    execute 'belowright '.rows.'new __MRU_BUFFER__'
    normal! ggdG
    setlocal buftype=nofile
    setlocal filetype=MRU

    "let n = len(g:MRU_FILES)
    "let i = 0
    "while i < n
        "call setline(i + 1, g:MRU_FILES[i])
        "let i += 1
    "endwhile
    call append(0, g:MRU_FILES)
    normal! ddgg
endfunction

function s:OpenFile()
    let path = getline('.')
    let s:mru_buffer_number = bufwinnr('__MRU_BUFFER__')
    execute s:mru_buffer_number . "bdelete"
    let g:mru_buffer_is_open = 0
    execute 'edit ' . path
endfunction

"function s:BrowseFile()
    "let path = getline('.')
    "execute s:active_window . "wincmd w"
    "execute 'edit ' . path
    "execute s:mru_window . "wincmd w"
"endfunction

autocmd FileType MRU nnoremap <buffer> o :call <SID>OpenFile()<cr>
"autocmd FileType MRU nnoremap <buffer> <tab> :call <SID>BrowseFile()<cr>
autocmd FileType MRU nnoremap <buffer> : <nop>
