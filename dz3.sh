#!/bin/bash

N=0
minimize=1
human_readable=false
directories=()
process_flags=true

usage() {
    echo "$0 [--help] [-h] [-N] [-s minsize] [--] [dir...]"
    exit 0
}
help_info() {
    echo "version: 1.1, author: Me"
    exit 0
}
while [[ $# -gt 0 ]]; do
    if $process_flags; then
        case "$1" in
            --usage) usage ;;
            --help) help_info ;;
            -h) human_readable=true; shift ;;
            -[0-9]*) N="${1:1}"; shift ;;
            -s) minsize="$2"; shift 2 ;;
            --) process_flags=false; shift ;;
            *) echo "Error: option not supported" >&2; exit 1 ;;
        esac
    else
        if [[ "$1" == -* ]]; then
            directories+=("./$1")
        else
            directories+=("$1")
        fi
        shift
    fi
done

if [[ ${#directories[@]} -eq 0 ]]; then
    directories=(.)
fi

find "${directories[@]}" -type f -size +"${minsize}c" -printf "%s %p\n" | sort -nr | {
    if $human_readable; then
        while read -r size path; do
            human_size=$(numfmt --to=iec-i --suffix=B "$size")
            echo "$human_size $path"
        done
    else
        cat
    fi
} | {
    if [[ $N -gt 0 ]]; then
        head -n "$N"
    else
        cat
    fi
}

exit 0
