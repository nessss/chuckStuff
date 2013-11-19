#!/bin/sh

cd ~/catGit/chuckStuff/classes/Sampler
find . -name *.wav > samplePaths.txt 2>/dev/null
find . -name *.aif >> samplePaths.txt 2>/dev/null
#chuck --dac2 SndBufPlus.ck SndBufN.ck Sampler.ck SamplerTest.ck
