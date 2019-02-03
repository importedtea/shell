#!/bin/bash

# IMPORTANT
# When you want to leave the tmux session, but keep it running use the following workflow
    # tmux detach
# To regain access
    # tmux attach -t work


# Setup a work space called `work` with two windows
# first window has 3 panes. 
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server 
# pane 3 is set to api root and bash prompt.
# note: `api` aliased to `cd ~/path/to/work`
#
session="work"

#one large screen on the left side and two smaller on the right
tmux new-session -s $session -d

#splits the window in half horizontally
#this adds the top pane on the right side
#sets the directory to ku from projects directory
tmux split-window -h
tmux send-keys "cd" C-m
tmux send-keys "clear" C-m

#splits the window in half vertically
#this adds the bottom pane on the right side
#sets the directory to ku from projects directory
tmux split-window -v
tmux send-keys "punchme" C-m


#selects the largest pane
#changes the directory to ku from projects directory
tmux selectp -t 0
tmux send-keys "cd scripts" C-m
tmux send-keys "clear" C-m

tmux -2 attach-session -d

############### different method #####################
#two screens on the top split in half
#one larger screen on the bottom
#tmux new-session -s $session -d
#tmux split-window -v
#tmux selectp -t 0
#tmux split-window -h
#tmux -2 attach-session -d
