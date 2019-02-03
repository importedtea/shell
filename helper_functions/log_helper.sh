#!/bin/bash

# log()     { [[ -t 1 ]] &&     echo "$@" || logger -t $(basename $0) "$@"; }
# log_err() { [[ -t 2 ]] && >&2 echo "$@" || logger -t $(basename $0) -p user.err "$@"; }

_log() { [[ -t 1 ]] && echo "$@" >> log.txt; }