#!/bin/bash
#$1 cookbook folder
#$2 rule folder
#$3 jobs
#$4 log file
find $1* -maxdepth 0 -type d | parallel -j$3 foodcritic -I "$2" -B {} >> "$4"