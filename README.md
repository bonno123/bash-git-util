# Bash utilities for git

## Type less with more confidence

`Bash-git-util` is designed to be used in conjunction with the bash shell. It abstracts away the git commands and allows to perform those in an interactive way.


Once you have installed `bash-git-util`, you can start using some frequently used git operations form your bash shell.

For example, you can use the `git_switch_interactive` function to switch between branches by simply choosing one form a dropdown


## Requirements
you will need:

 - A system with a bash shell 
 - Git installed on your system (requires git v1.7.10+)

## Install process
For now it could be installed directly by cloning this repo

1.   go to the directory you want to keep this repo
1.   then clone this repo using `git clone`
1.   and source that directory form shell

#### Now add these lines to your `~/.bashrc` or `.bash_profile`, to source this into your shell session:

```sh
export GIT_UTIL_DIR="$HOME/dev/bash-git-util"
[ -s "$GIT_UTIL_DIR/util.sh" ] && \. "$GIT_UTIL_DIR/bash-git-util.sh"   This loads git_functions
 ```
 
_**Important**:  The `GIT_UTIL_DIR` environment variable should point to the directory where `bash-git-util` is located. 
 If you have `bash-git-util` in a different directory, you can change the value of `GIT_UTIL_DIR` accordingly._

## usage

TODO:  add the documentation of usage
##


