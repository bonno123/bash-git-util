#! /usr/bin/bash

function source_bash_dropdown() {
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

source_bash_dropdown "bash_dropdown.sh"

function is_current_branch(){
    if [[ $1 == "*"* ]];
        then
            printf true
        else
            printf false
    fi
}

function trim_string(){
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf '%s' "$var"
}


function git_switch_interactive(){
    is_a_git_repo=$(git rev-parse --is-inside-work-tree) 

    
    if [[ -z $is_a_git_repo ]];
        then
            return
    fi
    
    #Set the field separator to new line
    IFS=$'\n'

    local gitBranchStdOut=$(git branch)

    declare -a branchesAsList=()  

    local branch_count=0
    local curent_branch=''

    # Iterate over each line
    for branch in $gitBranchStdOut
        do
            branch_count=$((branch_count+1))

            branch=$(trim_string $branch)

            current_branch=$(is_current_branch $branch)

            if [[ $current_branch == true ]];
                then
                   curent_branch=$branch
                else
                    branchesAsList+=("${branch}")
            fi


        done
    
    echo $curent_branch

    if [ "$branch_count" -eq "1" ]; then
        echo There is currently no branches available for switch;
        return;
    fi

    echo Select a branch out of  $((branch_count-1)) branches for switch [hint: use up/down keys and enter to confirm]:

    select_option "${branchesAsList[@]}"
    local selected_branch_index=$?
    local selected_branch=${branchesAsList[selected_branch_index]}

    if [ "$selected_branch_index" -eq "255" ]; then
        printf "\n\nAborting ...\n"
        return;
    fi

    git checkout $selected_branch 
}

