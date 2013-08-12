public class MidiSysex{
	MidiOut mout;
	MidiMsg msgs[];

	fun void open(int port){
		mout.open(port);
	}

	fun void open(string portName){
		mout.open(portName);
	}

	fun void send(int bytes[]){
		bytes.cap()/3=>int numMsgs;
		if(Math.remainder(bytes.cap(),3))numMsgs++;
		new MidiMsg[numMsgs]@=>msgs;
		for(int i;i<bytes.cap();i++){
			if(i%3==0){
				bytes[i]=>msgs[(i/3)].data1;
			}else if(i%3==1){
				bytes[i]=>msgs[(i/3)].data2;
			}else if(i%3==2){
				bytes[i]=>msgs[(i/3)].data3;
			}
		}
		for(int i;i<msgs.cap();i++){
			mout.send(msgs[i]);
		}
	}
}
