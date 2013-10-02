#!/bin/sh
cd `dirname $0`
ls ./compositions | grep '\.ck' > paths.txt
open -a miniAudicle randomChucK.ck
