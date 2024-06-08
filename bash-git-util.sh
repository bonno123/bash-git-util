#!/usr/bin/env bash

function source_git_functions() {
    local parent_dir
    local file_path

    parent_dir="$(dirname "$BASH_SOURCE")"
    file_path="$parent_dir/$1"

    if [ -f "$file_path" ]; then
        source "$file_path"
    else
        echo "file $1 not found"
    fi

}

source_git_functions "git_functions.sh"
update_git_branch_to_prompt
