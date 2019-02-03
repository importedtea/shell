#!/bin/bash

# Script first wrote on 05/31/18 as timesheet.sh
# Updated to punchme.sh on 06/05/18 when Project Manager was added.

# ISSUE 1
    # Add formatted output as in print_helper.sh
_log() { 
    for i in $1; do
		formatter=$(printf '%-10s' "$i")
		printf "\033[1;31m-> \033[0m%s : $2" "$formatter" >> test.log
	done
    #[[ -t 1 ]] && echo "$@" >> timesheet.log; 
}

_currproj() { 
    for i in $1; do
        # This will be changed to make directories, not redirect to .temp file
        echo $1 > .temp
	done
    #[[ -t 1 ]] && echo "$@" >> timesheet.log; 
}

_projlog() { 
    for i in $1; do
		formatter=$(printf '%-8s' "$i")
		printf "\033[1;31m-> \033[0m%s : $2" "$formatter" >> projects.log
	done
    #[[ -t 1 ]] && echo "$@" >> timesheet.log; 
}

function menu () {
    printf "\n${orange}Today is %s${reset}\n" "$log_date"
    
    printf "\nWhat would you like to do?: \n"
    printf "[1] Clock In\n"
    printf "[2] Lunch In\n"
    printf "[3] Lunch Out\n"
    printf "[4] Clock Out\n"
    printf "[P] Project Manager\n"
    printf "[q] Quit\n\n"
}

function read_opt () {
    local choice
    read -p "Enter what you would like to do: " choice
    
    case $choice in
        1) clock_in ;;
        2) _log "[L-OUT]" "Lunch taken at $log_date\n" && printf "Have a nice lunch\n\n" ;;
        3) _log "[L-IN]"  "Returned from lunch at $log_date\n" && printf "Welcome back\n\n" ;;
        4) clock_out ;;
        P) proj_mgmt ;;
        q) exit 0 ;;
    esac
}

# ISSUE 1
    # Attempted clock in at 8:09a.m. and else did not run
function clock_in () {
    local in=$(date +"%k%M")
    echo $in

    # There is probably a more elegant way of doing this.
    # The method of using the date as 830 helps with a lot of problems calculating the time
    if [[ "$in" > '830' ]]; then
        read -rp "What is your reason for being late? " late
        _log "[IN]" "Arrived late because of $late at $log_date\n"
        printf "Successfully Clocked in\n\n"
    else
        _log "[IN]" "Clocked in at $log_date\n"
        printf "Successfully Clocked in\n\n"
    fi
}

function clock_out () {
    local out=$(date +"%k%M")

    if [[ "$out" < '1535' ]]; then
        read -rp "What is your reason for clocking out early? " early
        _log "[OUT]" "Clocked out early because of $early at $log_date\n"
        printf "Successfully Clocked out\n\n"
    else
        _log "[OUT]" "Clocked out at $log_date\n"
        printf "Successfully Clocked out\n\n"
    fi
}

# This function can be expanded massively. There are a lot of cool ways of implementing.
# However, this will do for now for just keeping a simple log of some tasks.
function proj_mgmt () {
    clear; printf "Welcome to the Project Manager.\n"
    printf "It is currently ${orange}%s${reset}\n\n" "$log_date"

    read -rp "Are you starting a new project, updating, or ending? [ N / U / E / L ] " choice
    if [[ $choice == 'N' ]]; then
        read -rp "What project are you working on? " proj
        _currproj "$proj"
        _projlog "[START]" "Working on $proj at $log_date\n"
    elif [[ $choice == 'E' ]]; then 
        _projlog "[END]" "Ended project at $log_date\n\n"
    elif [[ $choice == 'L' ]]; then
        listProjects
    elif [[ $choice == 'R' ]]; then
        removeProjects
    else
        getCurrentProject
        while true; do
        # Add a way to show what project you are updating.
        # Maybe read from the project log and pull whatever last N proj was logged.
        # Maybe when selecting new project, have it save the name of the project in a .tmp folder
            # Read from .tmp folder to get project that you are working on
            read -rp "What update would you like to add? " proj_update
            _projlog "[UPDATE]" "$proj_update at $log_date\n"

        ## As of right now, just quit with Ctrl-C
        ## Want to implement a silent background way of quitting this update loop
            # read -t 0.25 -N 1 input
            # if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
            #     echo
            #     break 
            # fi
        done
    fi

}

function getCurrentProject () {
    # Add absolute path variable somewhere above; look into prm.sh and how they use paths
    FILE=.temp
    # Read from a \n delimeter text file
    while IFS='' read -r line || [[ -n "$line" ]]; do
        printf "The current project is %s\n" "$line"
    done < "$FILE"
}

function listProjects () {
    # Add absolute path variable somewhere above; look into prm.sh and how they use paths
    FILE=.projects
    counter=1
    # Read from a \n delimeter text file
    printf "Current Projects:\n"
    while IFS='' read -r line || [[ -n "$line" ]]; do
        printf "Project $counter: %s\n" "$line"
        counter=$( expr $counter + 1 )
    done < "$FILE"
}

# IDEA
# Instead of having a file with project names in it, create a directory for projects.
# prm uses the default $EDITOR value to add content to these files.
# In this script maybe we can just add a log file to a specific project
# Then listProjects will just basically ls the projects directory
# remove will remove a directory
# Update will add update log to that specific directory
    # This is great because it will split up all the information
# New project will add a directory to the projects directory

function removeProjects () {
    FILE=.projects
    # List the projects so the user knows what to delete.
    listProjects

    # Ask the user what they want to remove
    read -rp "What project do you want to remove? " remove

    # Remove said project
}

log_date=$(date "+%A %B%e %r %Y")

orange=$(tput setaf 3)
reset=$(tput sgr0)

menu
read_opt

