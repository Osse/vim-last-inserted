# vim-last-inserted

Show the last insert text on the statusline and how it was inserted.

Add this to your statusline:

    %#InsertedMode#%{LastInsertedMode()}%#InsertedSeparator#%{LastInsertedSeparator()}%#InsertededContents#%{LastInsertedContents()}

Full example that resembles the default statusline except with this information added:

    set statusline=%<%f\ %h%-4.4(%m%)%r%#LastInsertedMode#%{LastInsertedMode()}%#LastInsertedSeparator#%{LastInsertedSeparator()}%#LastInsertedContents#%{LastInsertedContents()}%0*%=%-14.(%l,%c%V%)\ %P

## Motivation

I often forget whether I pressed `i` or `a` when I last inserted some text. I
often end up doing the wrong thing when repeating my changes with `.` and only
create more work for myself rather than less. The same goes for `I` vs `A` and
`o` vs `O`.

## TODOs:

- Make the colors easily configurable,
- Make up some neater way of modifying the status line; the highlight groups
  make it difficult,
- Proper documentation,
- Perhaps have some info about the last yank? I also often don't know whether I
  should paste with `p` or `P`.
