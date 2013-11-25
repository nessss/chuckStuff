Sampler s;
s.init("snr");
chout<=s.numSounds<=IO.nl();

s.output=>dac;

MidiIn min;
min.open("Ableton Push User Port");
MidiOut mout;
mout.open("Ableton Push User Port");

int onColor;
int offColor;

chout<="Ready!"<=IO.nl();
while(min=>now){
	while(min.recv(MidiMsg msg)){
		if(msg.data1==0x90&msg.data2==36&msg.data3>0){
			send(0x90,36,onColor);
			s.trigger(Math.random2(0,s.numSounds-1));
		}else if(msg.data1==0x80&msg.data2==36){
			send(0x90,36,offColor);
		}
	}
}



fun void send(int d1,int d2,int d3){
	MidiMsg msg;
	d1=>msg.data1;
	d2=>msg.data2;
	d3=>msg.data3;
	mout.send(msg);
}
