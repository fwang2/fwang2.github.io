# My Vim Cheat Sheet


## Windows

    Ctrl-w + arrow key      switch window following directions

## Buffer management

    :bd     close current buffer

## Tags

You can generate tags by `ctags -R .`


    Ctrl + ]        go to (function) definition
    Ctrl + t        go back to previous location
    <Leader> tt     toggle the panel on-off

    :ta main        navigate to a specific function
    :ta /function   partial match a function
    :tn             go to next match

    :tj [tagname]   jump to a tag

## NERD tree

    Ctrl + e    turn it on / off

To keep left tab open, even when you open a new file

    let g:NERDTreeQuitOnOpen = 0

## Fuzzy find

    Ctrl + p    to goggle it
    ESC         to return




