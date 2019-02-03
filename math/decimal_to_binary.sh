#!/bin/bash

read -rp "What number would you like to convert? " dec

bc <<< "obase=2;$dec"
