#! /usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMAND_DIR="${SCRIPT_DIR}"/command


function help {
    cat <<EOS
procon-tool

Usage:
    procon-tool <command> [<args>...]
    procon-tool [options]

Options:
    -h, --help  Display this message

Commands:
EOS
    for command_dir in "${COMMAND_DIR}"/*; do
        str=$(pcregrep -o '(?<=ONELINE_HELP: ).*$' "$command_dir"/main.*)
        printf '    %-15s%s\n' $(basename "$command_dir") "$str"
    done
}


function main {
    if [ $# -eq 0 ]; then
        help
        exit 1
    fi

    local command_or_option=$1
    shift

    local regex='(^help$)|(^--help$)|(^-h$)'
    if [[ $command_or_option =~ $regex ]]; then
        help
        exit
    fi

    local dir="${COMMAND_DIR}"/$command_or_option
    if [ -e "$dir" ]; then
        local command=$(ls -1 "$dir"/main.*)
        local ext=${command##*.}

        if [ $ext = 'sh' ]; then
            exec bash $command $@
        elif [ $ext = 'py' ]; then
            exec python $command $@
        else
            echo "Not supported ext: $ext"
            exit 1
        fi
    else
        echo "No such command: $command_or_option"
        exit 1
    fi
}


main $@
