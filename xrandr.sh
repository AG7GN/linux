#!/bin/bash
#
# Script to add a resolution to a "dummy" monitor. 
# Written by chirag64 https://gist.github.com/chirag64/7853413
#
#If no argument is specified, ask for it and exit
if [[ -z "$@" ]];
then
    echo "An argument is needed to run this script";
    exit
else
    arg="$@"
    #Basic check to make sure argument number is valid. If not, display error and exit
    if [[ $(($(echo $arg | grep -o "\s" | wc --chars) / 2 )) -ne 2 ]];
    then
        echo "Invalid Parameters. You need to specify parameters in the format \"width height refreshRate\""
        echo "For example setResolution \"1920 1080 60\""
        exit
    fi
    
    #Save stuff in variables and then use xrandr with those variables
    modename=$(echo $arg | sed 's/\s/_/g')
    display=$(xrandr | grep -Po '.+(?=\sconnected)')
    if [[ "$(xrandr|grep $modename)" = "" ]];
    then
        xrandr --newmode $modename $(gtf $(echo $arg) | grep -oP '(?<="\s\s).+') &&
        xrandr --addmode $display $modename     
    fi
    xrandr --output $display --mode $modename

    #If no error occurred, display success message
    if [[ $? -eq 0 ]];
    then
        echo "Display changed successfully to $arg"
    fi
fi
