public class PushUtility{
	//=================================================================
	//
	//		A class for dealing with all of the fun parts of
	//		interfacing with Ableton Push, including functionality
	//		requiring sysex output.
	//
	//		note: in order to retrieve midi sysex data returned 
	//			  by enquiry functions,
	//			  you must use another program, as ChucK does not (yet)
	//			  support sysex input.
	//
	//.................................................................
	
	MidiSysex mS;
	MidiOut mout;
	int start[];
	int clearLineSysex[];  
	int touchStripSysex[];
	

	int SOLID_ON;
	int NANO_FADE_ON;
	int QUICK_FADE_ON;
	int FADE_ON;
	int SLOW_FADE_ON;
	int SLOWER_FADE_ON;

	int SOLID_OFF;
	int NANO_FADE_OFF;
	int QUICK_FADE_OFF;
	int FADE_OFF;
	int SLOW_FADE_OFF;
	int SLOWER_FADE_OFF;


	fun void init(){
		mS.open("Ableton Push User Port");
		mout.open("Ableton Push User Port");

		[240,71,127,21]@=>start;
		[28,0,0,247]@=>clearLineSysex;
		[99,0,1,0,247]@=>touchStripSysex;

		0x90=>SOLID_ON;
		0x91=>NANO_FADE_ON;
		0x92=>QUICK_FADE_ON;
		0x93=>FADE_ON;
		0x94=>SLOW_FADE_ON;
		0x95=>SLOWER_FADE_ON;

		0x80=>SOLID_OFF;
		0x81=>NANO_FADE_OFF;
		0x82=>QUICK_FADE_OFF;
		0x83=>FADE_OFF;
		0x84=>SLOW_FADE_OFF;
		0x85=>SLOWER_FADE_OFF;
	}

	fun void fade(int pad,int c1,int c2,int speed){
		MidiMsg msg;
		0x90=>msg.data1;
		pad=>msg.data2;
		c1=>msg.data3;
		mout.send(msg);
		0x90+speed=>msg.data1;
		c2=>msg.data3;
		mout.send(msg);
	}

	fun void fadeLoop(int pad,int c1,int c2,int style,dur t){
		MidiMsg msg;
		pad=>msg.data2;
		while(true){
			c1=>msg.data3;
			0x90=>msg.data1;
			mout.send(msg);
			c2++;
			c2=>msg.data3;
			0x90+style=>msg.data1;
			mout.send(msg);
			t=>now;

			c2=>msg.data3;
			0x90=>msg.data1;
			mout.send(msg);
			c1++;
			c1=>msg.data3;
			0x90+style=>msg.data1;
			mout.send(msg);
			t=>now;
		}
	}

	fun void clearLine(int line){
		line=>clearLineSysex[3];
		mS.send(ArrayTools.concat(start,clearLineSysex));
	}

	fun void touchStrip(int mode){
		28+mode=>clearLineSysex[0];
		mS.send(ArrayTools.concat(start,touchStripSysex));
	}

	fun void aftertouchEnquiry(){ // not sure if this works
		mS.send(ArrayTools.concat(start,[92,0,0,247]));
	}

	fun void setAfterTouch(int mode){
		if(mode)1=>mode;
		mS.send(ArrayTools.concat(start,[92,0,1,mode,247]));
	}

	fun void touchStripFreeMsg(int states[]){
		if(states.size()!=24)24=>states.size;
		int bytes[8];
		for(int i;i<24;i++){
			states[i]<<(2*(i%3))|=>bytes[i/3];
		}
		mS.send(ArrayTools.concat(ArrayTools.concat(start,[100,0,8]),bytes,[247]));
	}
	
	fun int[] toBytes(int n,int size){
		int bytes[size];
		if(n<=(1<<(4*size))){
			for(int i;i<size;i++){
				n<<(i*4)&15=>bytes[i];
			}
		}
		return bytes;
	}

	//==================--| LCD Functions |--==========================

	fun void contrastEnquiry(){
		mS.send(ArrayTools.concat(start,[122,0,0,247]));
	}

	fun void setContrast(int c){
		mS.send(ArrayTools.concat(start,[122,0,1,c,247]));
	}

	fun void brightnessEnquiry(){
		mS.send(ArrayTools.concat(start,[124,0,0,247]));
	}

	fun void setBrightness(int b){
		mS.send(ArrayTools.concat(start,[124,0,1,b,247]));
	}

	//==================--| Fun Functions |--===============

	fun void stripAnim(){
		int strip[24];
		20::ms=>dur d;
		while(true){
			for(int i;i<24;i++){
				for(int j;j<24;j++){
					if(i>j)1=>strip[j];
					else 0=>strip[j];
				}
				touchStripFreeMsg(strip);
				d=>now;
			}
			for(int i;i<24;i++){
				for(int j;j<24;j++){
					if(i<j)1=>strip[j];
					else 0=>strip[j];
				}
				touchStripFreeMsg(strip);
				d=>now;
			}
		
		}

	}
				
	fun void checkerFade(int c1,int c2,dur t){
		for(int i;i<64;i++){
			if(i%2){
				if((i/8)%2){
					spork~fadeLoop(i+36,c2,c1,5,2::second);
				}else{
					spork~fadeLoop(i+36,c1,c2,5,2::second);
				}
			}else{
				if((i/8)%2){
					spork~fadeLoop(i+36,c1,c2,5,2::second);
				}else{
					spork~fadeLoop(i+36,c2,c1,5,2::second);
				}
			}
		}
	}
}
