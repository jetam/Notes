# Tab completion for mymn. Load it from ~/.bashrc:
#     source ~/code/Notes/mymn-completion.bash
#
#   mymn <TAB>              first word of every entry
#   mymn kubectl <TAB>      get  describe  logs  exec  config ...
#   mymn kubectl ro<TAB>    ->  rollout

_mymn() {
    local cur="${COMP_WORDS[COMP_CWORD]#-}"
    local words=("${COMP_WORDS[@]:1:COMP_CWORD-1}")    # words before the cursor

    # after -grep you type a free pattern -> no suggestions
    local w
    for w in "${words[@]}"; do
        [[ "$w" == "-grep" || "$w" == "--grep" || "$w" == "-g" ]] && { COMPREPLY=(); return; }
    done

    # entries whose first words match what was typed -> offer their next word.
    # Words with shell-special characters are skipped so they can't break the line.
    local typed="${words[*]}"; typed="${typed#-}"
    mapfile -t COMPREPLY < <(
        mymn --entries 2>/dev/null | awk -v p="${typed,,}" -v cur="${cur,,}" '
            p == "" { w = $1 }
            p != "" { if (index($0, p " ") != 1) next
                      split(substr($0, length(p) + 2), a, " "); w = a[1] }
            w ~ /^[a-z0-9._+-]+$/ && index(w, cur) == 1 { print w }
        ' | sort -u
    )
}

complete -F _mymn mymn
