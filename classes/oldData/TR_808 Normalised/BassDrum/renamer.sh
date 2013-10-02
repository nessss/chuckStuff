#!/bin/sh

if [ $# -ne 1 ]
then
	echo "Arguments: <pattern to remove from files>"
	exit 1
fi

for file in *.aif
do
	mv "$file" "${file/KickDrum/}"
done

