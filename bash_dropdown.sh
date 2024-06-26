#!/usr/bin/env bash

# following: https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu

# Renders a text based list of options that can be selected by the user 
# using up, down and enter keys and returns the chosen option.

ESC=$( printf "\033")

reset_format=$ESC[0m

normal_italic_blue=$ESC'[0;3;94m'
bold_normal_blue=$ESC'[1;0;94m'

bright_text_normal_underline_blue=$ESC'[1;1;4;94m'

selection_arrow='\u27A6'

up_arrow_key=$ESC[A
down_arrow_key=$ESC[B
enter_key=''

# helpers related to cursor
function cursor_blink_on  { printf "$ESC[?25h"; }
function cursor_blink_off { printf "$ESC[?25l"; }

function cursor_to { printf "$ESC[$1;${2:-1}H"; }

# helpers for print format
function print_option { printf "   $normal_italic_blue$1  $reset_format"; }
function print_selected { 
    printf " $bold_normal_blue$selection_arrow $dim_text_normal_underline_blue$1$reset_format"; 
}



function get_cursor_row { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }

function trap_ctrlc() {
    # echo -e "\n\ntrap_ctrlc\n"
    trap "cursor_blink_on; stty echo; printf '\n';return 255" 2
}

#   Arguments   : list of options, maximum of 256 ("opt1" "opt2" ...)
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {
    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; 
        do printf "\n"; 
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    # trap "cursor_blink_on; stty echo; printf '\n'; exit" 1
    trap_ctrlc
    cursor_blink_off

    local selected=0
    
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter)  break;;

               up)  ((selected--));
                    if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;

             down)  ((selected++));
                    if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

function key_input {
    read -s -n3 key 2>/dev/null >&2

    if [[ $key = $up_arrow_key ]]; then 
        echo up;    
    fi;

    if [[ $key = $down_arrow_key ]]; then 
        echo down;  
    fi;

    if [[ $key = $enter_key ]]; then 
        echo enter; 
    fi; 

}
