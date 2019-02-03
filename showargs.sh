#!/bin/bash

exec 1>&2
echo "$0: $# parameter(s):"
for i
do echo "You have used the following paramater(s): <$i>"
done
exit 0
