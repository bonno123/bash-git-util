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


add_git_branch_to_prompt() {
    local git_branch
    git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\](\[\033[0;36m\]*$git_branch\[\033[00m\])$ "
    fi
}

source_git_functions "git_functions.sh"
add_git_branch_to_prompt


# add the following to your .bashrc or .bash_profile

# export GIT_UTIL_DIR="$HOME/dev/bash-git-util"
# [ -s "$GIT_UTIL_DIR/util.sh" ] && \. "$GIT_UTIL_DIR/util.sh"  # This loads git_functions
