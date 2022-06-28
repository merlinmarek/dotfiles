[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && eval $(ssh-agent) && exec startx
