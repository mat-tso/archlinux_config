#!/bin/env bash

set -euo pipefail

usage="Usage $0 <command number> [<argument>...]
Commands:
    1) List installed package
    2) Display database
    3) Display database with description
    4) grep argument in tags of install package
    5) In database but not installed
    6) Installed but not in database
    "

cmd[1]="pacman -Qei | sed -ne's/Nom *: //p' \
                           -e's/Description *: //p' |
                      sed 'N;s/\n/|/'" 
cmd[2]="sed -r 's/ +/|/' install_database.txt"
cmd[3]="join -t \| <(${cmd[2]}) <(${cmd[1]})"
cmd[4]="join -t \| <(${cmd[2]} | grep -e '${2:-}') <(${cmd[1]})"
cmd[5]="${cmd[3]} -v1"
cmd[6]="${cmd[3]} -v2"


case "${1:-}" in
    [0-9]) eval "${cmd[$1]}" | column -ts'|' ;;
    *) echo "$usage"
esac
