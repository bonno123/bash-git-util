#!/usr/bin/env bash

# source ~/$HOME/bash-functions/bash_dropdown.sh
parent_dir="$(dirname "$BASH_SOURCE")"
echo "Parent directory: $parent_dir"

file_path="$(dirname "$BASH_SOURCE")/git_functions.sh"

if [ -f "$file_path" ]; then
    source "$file_path"
else
    echo "git_functions not found"
fi

add_git_branch_to_prompt() {
    local git_branch
    git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        PS1="($git_branch) $PS1"
    fi
}

add_git_branch_to_prompt


# add the following to your .bashrc or .bash_profile

# export GIT_UTIL_DIR="$HOME/dev/bash-git-util"
# [ -s "$GIT_UTIL_DIR/util.sh" ] && \. "$GIT_UTIL_DIR/util.sh"  # This loads git_functions
