SinOsc s=>ADSR aEnv=>dac;

OscSend xmit;

xmit.setHost("portocat.local",1123);

float pitch;
Event noteOn;
Event noteOff;
Event pitchEvent;

MidiIn min;
<<<0x92&0xe0>>>;

0=>int nextChan;

min.open("Network Session 1");
spork~pitchListen();
//spork~noteListen();
spork~fingerTrack();
timePrint();

fun void timePrint(){
	int c;
	while(200::ms=>now){
		//<<<c++>>>;
	}
}

fun void midiPrint(){
	MidiMsg msg;
	while(min=>now){
		while(min.recv(msg)){
			if((msg.data1&0xf0)==0xe0){
				<<<"Ch: "+(msg.data1&0x0f),"PB: "+(((msg.data3<<7)|msg.data2)-8192)>>>;
			}else if((msg.data1&0xf0)==0x90){
				if(msg.data3){
					<<<"Ch: "+(msg.data1&0x0f),"On: "+msg.data2+" V: "+msg.data3>>>;
				}else{
					<<<"Ch: "+(msg.data1&0x0f),"Off: "+msg.data2>>>;
				}
			}else if((msg.data1&0xf0)==0x80){
				<<<"Ch: "+(msg.data1&0x0f),"Off: "+msg.data2>>>;
			}else if((msg.data1&0xf0)==0xb0){
				<<<"Ch: "+(msg.data1&0x0f),"CC: "+msg.data2,msg.data3>>>;
			}else if((msg.data1&0xf0)==0xd0){
				<<<"Ch: "+(msg.data1&0x0f),"AT: "+msg.data2,msg.data3>>>;
			}else{
				<<<msg.data1,msg.data2,msg.data3>>>;
			}
		}
	}
}

fun void pitchListen(){
	while(pitchEvent=>now){
		Std.mtof(pitch)=>s.freq;
		xmit.startMsg("/p, f");
		xmit.addFloat(pitch);
	}
}

fun void noteListen(){
	while(true){
		noteOn=>now;
		aEnv.keyOn();

		noteOff=>now;
		aEnv.keyOff();
	}
}



fun void fingerTrack(){
	MidiMsg msg;

	(1.0/8192.0)=>float bendNorm;

	int chan;
	int note;
	int pb;
	int hopFlag;
	int on;
	int playingVoices;

	int onFlag;
	int offFlag;

	float bendPitch;

	2=>int bendRange;


	while(min=>now){
		while(min.recv(msg)){
			if((msg.data1&0xf0)==0x90){ // notes
				if(msg.data3){		// note on
					if(!onFlag){
						msg.data1&0x0f=>chan;
						msg.data2=>note;
						chan+1=>nextChan;
						if((!on)&&(!hopFlag))noteOn.broadcast();
						1=>on;
						0=>hopFlag;
						playingVoices++;
						1=>onFlag;
					}else 0=>onFlag;
				}else{				// note off
					if(!offFlag){
						0=>on;
						if(!hopFlag)noteOff.broadcast();
						playingVoices--;
						1=>offFlag;
					}else 0=>offFlag;
				}
			}else if((msg.data1&0xf0)==0xe0){  // pitch bend
				if((msg.data1&0x0f)==chan){
					(((msg.data3<<7)|msg.data2)-8192)=>pb;
					//<<<pb, bendNorm>>>;

					(pb$float)*bendNorm*(bendRange$float)=>bendPitch;
				}
			}else if((msg.data1&0xf0)==0xb0){  // CCs
				if((msg.data1&0x0f)==chan){
					if(msg.data2!=11){
						//<<<msg.data1&0x0f,msg.data2,msg.data3>>>;
					}
					if((msg.data2==0x63)&&(msg.data3==0x09)){
						1=>hopFlag;
					}
				}
			}
			//<<<bendPitch>>>;
			(note$float)+bendPitch=>pitch;
			pitchEvent.broadcast();
		}
		//<<<pitch,"">>>;
		//<<<playingVoices>>>;
		//<<<"Next: "+nextChan>>>;
		//<<<chan, note, pb>>>;
	}
}
