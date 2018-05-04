#!/bin/bash     
#needs knife installed
waitforjobs() {
    while test $(jobs -p | wc -w) -ge "$1"; do wait -n; done
}

if [ -z "$1" ]; then
exit
fi
[[ -d $1 ]] || mkdir -p $1
cd $1
if [ -z "$2" ]; then
#LIST="$(knife cookbook site list)"
knife cookbook site list > /tmp/knife-download-list.tmp
while read line; do
    for word in $line; do
        waitforjobs 16
        knife cookbook site download $word &
    done
done < "/tmp/knife-download-list.tmp" #< "$LIST"
wait
rm /tmp/knife-download-list.tmp
else
#LIST="$(knife cookbook site list -c $2)"
knife cookbook site list -c $2 > /tmp/knife-download-list-custom.tmp
while read line; do
    for word in $line; do
        waitforjobs 16
        knife cookbook site download $word -c $2 &
    done
done < "/tmp/knife-download-list-custom.tmp" #< "$LIST"
wait
rm /tmp/knife-download-list-custom.tmp
fi
