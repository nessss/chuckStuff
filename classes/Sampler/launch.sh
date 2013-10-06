#!/bin/sh

cd data
ls *.wav *.aif > samplePaths.txt 2>/dev/null
cd ..
chuck --dac3 SndBufPlus.ck SndBufN.ck Sampler.ck MidiEvent.ck MidiBroadcaster.ck Push.ck PushKnob.ck Rack.ck
