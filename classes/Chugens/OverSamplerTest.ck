SinOsc s=>OverSampler os=>dac;
//OverSampler os;
MidiIn min;
min.open("nanoKONTROL2 SLIDER/KNOB");
SndBuf buf;//=>OverSampler os=>dac;
buf.read("/Users/portocat/Desktop/amen_brother.wav");
//SinOsc s=>dac;

25=>os.distAmt;
os.init(4);

2=>os.outGain;

spork~midiLoop();
while(buf.samples()::samp=>now)buf.pos(0);

fun void midiLoop(){
	while(min=>now){
		while(min.recv(MidiMsg msg)){
			if(msg.data1==0xB0&msg.data2==0x10){
				49*(1.0/127.0)*msg.data3+1=>os.distAmt;
			}
		}
	}
}
