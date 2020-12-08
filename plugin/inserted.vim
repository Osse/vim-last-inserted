let s:last_ins_mode = ''
let s:last_inserted = ''
let s:content_max = 10

function! s:start_and_store(key)
    let s:last_ins_mode = a:key
    return a:key
endfunction

highlight InsertedMode cterm=bold ctermbg=253 ctermfg=167
highlight InsertedColon cterm=bold ctermbg=253 ctermfg=66
highlight InsertedContents cterm=bold ctermbg=253 ctermfg=88

function! s:set_last_string(inserted)
    if len(a:inserted) == 0
        let s:last_inserted = ""
        return
    endif

    let last_split = split(a:inserted, "\n")
    if len(last_split) == 0
        let l:last_inserted = ""
    else
        let l:last_inserted = last_split[0]
        if len(l:last_inserted) > s:content_max
            let l:last_inserted = l:last_inserted[0:s:content_max] . "..."
        endif
    endif

    if len(last_split) > 1
        let l:last_inserted .= printf(" (%d more lines)", len(last_split) - 1)
    endif

    let s:last_inserted = l:last_inserted
endfunction

" Set up mappings that start insert mode
for k in ['i', 'I', 'a', 'A', 'o', 'O']
    execute 'nnoremap <expr>' k '<SID>start_and_store("'.k.'")'
endfor

augroup Inserted
    " Text is changed in normal mode -> last_inserted inserted is no longer relevant
    autocmd TextChanged * let s:last_ins_mode = ''

    " Update what's shown
    autocmd InsertLeave * call s:set_last_string(getreg('.'))
augroup END

" Main plugin function to be called from outside
" function! LastInsert()
"     if mode() == 'i'
"         return "ins"
"     elseif s:last_ins_mode == ''
"         return ""
"     endif
"     return s:last_inserted
" endfunction

function! LastInsertMode()
    if mode() == 'i'
        return "ins"
    endif
    return s:last_ins_mode
endfunction

function! LastInsertSeparator()
    if mode() == 'i' || s:last_ins_mode == ''
        return ""
    endif
    return ": "
endfunction

function! LastInsertContents()
    if mode() == 'i' || s:last_ins_mode == ''
        return ""
    endif
    return s:last_inserted
endfunction
