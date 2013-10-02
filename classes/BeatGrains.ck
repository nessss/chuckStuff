public class BeatGrains{
	MidiIn min;
	NanoKONTROL2 nK;

	Pan2 in;
	Pan2 out;
	Pan2 dry;
	Pan2 wet;

	Pan2 fb[];
	Delay del[];
	LiSa la;

	fun void init(int voices){
		new Delay[voices]@=>del;
		new Pan2[voice]@=>fb;
		for(int i;i<del.size();i++){
			in=>dry=>out;
			wet=>out;
			in=>del[i];
			del[i]=>wet;
			del[i]=>fb[i];
			fb[i]=>del[i];
			fb[i].gain(0);
		}
		midiInit();
	}

	fun void midiInit(){
		if(!min.open("nanoKONTROL2 SLIDER/KNOB")){
			cherr << "Couldn't open nanoKONTROL2 MIDI communications..." << cherr.newline();
		}
	} 

	fun void midiLoop(){
		MidiMsg msg;
		while(min.recv(msg)){
			(msg.data3$float/127.0)=>float data;
			if(nK.isFader(msg.data2)){
				faderFun(nK.faderNum(msg.data2),data);
			}else if(nK.isKnob(msg.data2)){
				knobFun(nK.knobNum(msg.data2),data);
			}else if(nK.isButton(msg.data2)){
				buttonFun(nK.buttonNum(msg.data2),data);
			}else if(nK.isTransport(msg.data2)){
				transportFun(nK.transportNum(msg.data2),data);
			}
		}
	}

	fun void knobFun(int k,float data){
		if(k==0)inputGain(data);
		else if(k==1)compressorThreshold(data);
		else if(k==2)compressorRatio(data);
		else if(k==3)
		else if(k==4)
		else if(k==5)
		else if(k==6)
		else if(k==7)
	}

	fun void connect(UGen i,UGen o){
		i=>in;
		out=>o;
	}

	fun void tune(int d,float p){
		Std.mtof(p)=>float f;
		del[d].delay((1.0/f)::second);
	}

	fun void harmonicSeries(){
		del[0].delay()=>dur d;
		for(1=>int i;i<del.size();i++){
			del[i](d/(i+1))
		}
		for(int i;i<del.size();i++){
			del[i].gain(1.0/(i+1));
		}
	}

	fun float feedback(float g){
		for(int i;i<fb.size();i++){
			fb[i].gain(g);
		}
		return fb[0].gain();
	}
	
	fun float scale(float in;float min,float max){
		max-min=>float range;
		return in*range+min;
	}
}
