#!/bin/bash

read -rp "Name? " name
read -rp "Building? " building
read -rp "Department? " dept
read -rp "Full Time / Part Time? " fptime
read -rp "Account Expiration [does / does not]? " expire
if [[ $expire == "does" ]]; then
    read -rp "What date does it expire on? " expdate
    export expdate
fi

read -rp "Job Description? " desc

read -rp "Do they need files from the previous user? " fil
if [[ "$fil" == "yes" ]]; then
    read -rp "Who is the previous user? " prevuser
    export $prevuser
fi


export $fil
export $name
export $dept
export $building
export $desc
export $fptime
export $expire

. ./staff_create.sh
