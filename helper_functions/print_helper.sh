#!/bin/bash

# Flag to control function use
# Not necessary, but an alternate way of implementing
verbosity=1

# _verbose helper function, take arguments of function below...
# place into printf and display to screen
_verbose_flag () {
    if [[ "$verbosity" -eq "1" ]]; then
		printf "\033[1;31m-> \033[0m$1\n"
	fi
}

_verbose_noflag () {
	printf "\033[1;31m-> \033[0m$1\n"
}

_verbose_noflag_formatted () {
	for i in $1; do
		formatter=$(printf '%-40s' "$i")
		printf "\033[1;31m-> \033[0m%s : $2\n" "$formatter"
	done
}

# Example helper call with passed input
printf "\nYou will notice no difference between w/ or w/out flags unless you look at the code \
where verbosity=1\n"
_verbose_flag        "Verbose w/ Flags : test"

_verbose_noflag "Verbose w/out Flags : test"

printf "\n\nThese are two examples of formatted text functions, each one containing \
more characters at the left align\n"
_verbose_noflag_formatted "Formatted1" "Formatted"
_verbose_noflag_formatted "Formatted22222" "Formatted"
