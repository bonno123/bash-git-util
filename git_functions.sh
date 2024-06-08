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

update_git_branch_to_prompt() {
    # local git_branch
    git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\](\[\033[0;36m\]*$git_branch\[\033[00m\])$ "

    else
        PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m$ "
    fi
}

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

function git_switch_new(){
    local branch_name

    # if argument is passed
    if [[ ! -z $1 ]];
        then
            branch_name=$1
        else # read branch_name from user
            echo "Enter the name you want to give to the new branch: "
            read -p "" branch_name

            if [[ -z $branch_name ]];
                then
                    echo "Branch name cannot be empty"
                    return
            fi
    fi

    # check if the branch already exists  
    local branch_exists=$(git branch --list $branch_name)

    if [[ ! -z $branch_exists ]];
        then
            echo "Branch with name $branch_name already exists"

            echo "Do you want to switch to the existing branch? [y/n]"
            read -p "" switch_to_existing_branch

            if [[ $switch_to_existing_branch == "y" ]];
                then
                    git checkout $branch_name | tee /dev/fd/2
                    update_git_branch_to_prompt
            fi

            return
    fi

    echo "creating and switching to the new branch ..."
    git checkout -b $branch_name | tee /dev/fd/2
    update_git_branch_to_prompt

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
    update_git_branch_to_prompt
}

