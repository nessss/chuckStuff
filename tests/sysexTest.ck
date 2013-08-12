PushUtility pU;
MidiIn min;
MidiMsg msg;
min.open("Ableton Push User Port");
pU.init();

pU.mS.send(ArrayTools.concat(pU.start,[1,1,247]));
spork~pU.stripAnim();

while(min=>now){
	while(min.recv(msg)){
		if(msg.data1==0x90){
			pU.fade(msg.data2,64,0,3);
		}
	}
}



while(samp=>now);
