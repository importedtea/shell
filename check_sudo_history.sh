#!/bin/bash

# instead of having multiple users as cmd args, just have one user only
# then no for loop will be needed.
for user in "${@}"; do
    cat /var/log/auth.log | grep $user
done