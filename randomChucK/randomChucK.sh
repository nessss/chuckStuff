#!/bin/sh
ls ./compositions | grep '\.ck' > paths.txt
open -a miniAudicle randomChucK.ck
