#!/bin/sh

ls ./data | grep '\.wav' > ./data/samplePaths.txt
ls ./data | grep '\.aif' >> ./data/samplePaths.txt
chuck sampLaunch.ck
