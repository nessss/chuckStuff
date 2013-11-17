#!/bin/sh

cd data
ls *.wav *.aif > samplePaths.txt 2>/dev/null
cd ..
chuck --dac4 --bufsize256 SndBufPlus.ck SndBufN.ck Sampler.ck SamplerTest.ck
