" Cache
let s:last_ins_mode = ''
let s:last_inserted = ''

" User settings
let s:content_max = get(g:, 'last_insert_max_len', 10)

" TODO: Make this easily configurable
highlight LastInsertedMode cterm=bold ctermbg=253 ctermfg=167
highlight LastInsertedColon cterm=bold ctermbg=253 ctermfg=66
highlight LastInsertedContents cterm=bold ctermbg=253 ctermfg=66

function! s:store(key)
    let s:last_ins_mode = a:key
    return a:key
endfunction

" Remove a sequence of x<80>kb which indicates that <BS> has been pressed
" during insert. If getreg('.') contains 'aaabbb<80>kb<80>kb<80>kbccc' Vim
" will insert 'aaaccc' and so the last inserted string should be that as well.
function! s:clean_bs(str)
    let pos = match(a:str, '[\x80]kb')
    if pos < 0
        return a:str
    endif

    let rawlen = len(matchstr(a:str, '\([\x80]kb\)\+'))
    let len = rawlen/3 " <80>kb is three bytes

    if len >= pos
        " More backspaces than text before. Return latter half
	return a:str[pos+rawlen:-1]
    endif

    return a:str[0:pos-len-1].a:str[pos+rawlen:-1]
endfunction

function! s:set_last_string(inserted)
    let inserted = s:clean_bs(a:inserted)
    if len(inserted) == 0
        let s:last_inserted = ""
        return
    endif

    let last_split = split(inserted, "\n")
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

" Set up mappings that start insert mode. AFAIK there is no way to discover
" how insert mode was entered
for k in ['i', 'I', 'a', 'A', 'o', 'O', 'c']
    execute printf('nnoremap <expr> %s <SID>store(''%s'')', k, k)
endfor

augroup LastInserted
    " Text is changed in normal mode, thus last_inserted inserted is no longer relevant
    autocmd TextChanged * let s:last_ins_mode = ''

    " Update what's shown
    autocmd InsertLeave * call s:set_last_string(getreg('.'))
augroup END

" Add to statusline somewhere (better way to write this?):
"
" %#InsertedMode#%{LastInsertedMode()}%#InsertedSeparator#%{LastInsertedSeparator()}%#InsertededContents#%{LastInsertedContents()}

" Public functions
function! LastInsertedMode()
    if mode() == 'i'
        return "ins"
    endif
    return s:last_ins_mode
endfunction

function! LastInsertedSeparator()
    if mode() == 'i' || s:last_ins_mode == ''
        return ""
    endif
    return ": "
endfunction

function! LastInsertedContents()
    if mode() == 'i' || s:last_ins_mode == ''
        return ""
    endif
    return s:last_inserted
endfunction
