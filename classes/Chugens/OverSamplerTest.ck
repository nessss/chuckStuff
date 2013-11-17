//SinOsc s=>OverSampler os=>dac;
SndBuf buf=>OverSampler os=>dac;
buf.read("/Users/portocat/Desktop/amen_brother.wav");
//SinOsc s=>dac;

500=>os.distAmt;
os.init(5);
os.printCoef();

2=>os.outGain;

9::second=>now;
chout<=os.last()<=IO.nl();
