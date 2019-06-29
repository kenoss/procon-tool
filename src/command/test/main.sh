#! /usr/bin/env bash

# ONELINE_HELP: Check test cases.


RED=$(tput setaf 1);
GREEN=$(tput setaf 2);
RESET=$(tput sgr0);

OK="${GREEN}OK${RESET}:"
FAIL="${RED}FAIL${RESET}:"


function help {
    cat <<EOS
procon-tool test

Usage:
    procon-tool test            # test all test cases
    procon-tool test <n>        # test the test case #n
    procon-test test <options>

Options:
    -h, --help  Display this message
EOS
}


function test-build {
    local f=$(ls -1 src/main.*)
    local ext=${f##*.}

    if [ $ext = 'rs' ]; then
        cargo build
    elif [ $ext = 'py' ]; then
        :
    else
        echo 'Not supported language'
        exit 1
    fi
}


function test-run {
    local f=$(ls -1 src/main.*)
    local ext=${f##*.}

    if [ $ext = 'rs' ]; then
        cargo run
    elif [ $ext = 'py' ]; then
        python "$f"
    else
        echo 'Not supported language'
        exit 1
    fi
}


function procon-test-all {
    local dir="$1"

    for d in "$dir"/*; do
        echo ----------------------------------------------------------------------------------------------------

        if diff <(cat "$d"/input.txt | test-run 2>/dev/null) <(cat "$d"/output.txt) >/dev/null; then
            echo $OK $(basename "$d")
        else
            echo $FAIL $(basename "$d")
            echo ----------------------------------------------------------------------------------------------------
            echo got:
            cat "$d"/input.txt | test-run
            echo ----------------------------------------------------------------------------------------------------
            echo expected:
            cat "$d"/output.txt
        fi

        echo ----------------------------------------------------------------------------------------------------
        echo
    done
}


function procon-test-one {
    local d="$1"

    echo ----------------------------------------------------------------------------------------------------

    if diff <(cat "$d"/input.txt | test-run 2>/dev/null) <(cat "$d"/output.txt) >/dev/null; then
        echo $OK $(basename "$d")
    else
        echo $FAIL $(basename "$d")
    fi

    echo ----------------------------------------------------------------------------------------------------
    echo got:
    cat "$d"/input.txt | test-run
    echo ----------------------------------------------------------------------------------------------------
    echo expected:
    cat "$d"/output.txt
    echo ----------------------------------------------------------------------------------------------------
}


function get-dir {
    local dir_local="$PWD"/procon-tool/test-case
    local dir_env="$PROCON_TOOL_MASTER_DATA_DIRECTORY"
    local dir_master="$dir_env"/$(pwd | pcregrep -o '[^./]+\.[^./]+/[^./]+$' | tr . /)/test-case

    if [ -d "$dir_local" ]; then
        echo "$dir_local"
    elif [ -n "$dir_env" ] && [ -d "$dir_master" ]; then
        echo "$dir_master"
    else
        :
    fi
}


function main {
    local dir=$(get-dir)

    if [ -z "$dir" ]; then
        echo "${RED}Error${RESET}: test case not found"
        exit 1
    fi

    local command_or_option=$1

    local regex='(^help$)|(^--help$)|(^-h$)'
    if [[ $command_or_option =~ $regex ]]; then
        help
        exit
    fi

    if [ ! -e src/main.* ]; then
        echo "${RED}Error${RESET}: source code not found: src/main.*"
        exit 1
    fi

    echo ----------------------------------------------------------------------------------------------------
    test-build
    local success=$?
    echo ----------------------------------------------------------------------------------------------------
    echo

    if [ $success -gt 0 ]; then
        exit 1
    elif [ $# -eq 0 ]; then
        procon-test-all "$dir"
    elif [ $# -eq 1 ]; then
        local n=$(printf '%02d' $command_or_option)
        procon-test-one "$dir"/$n
    else
        help
        exit 1
    fi
}


main $@
