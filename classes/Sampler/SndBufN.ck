public class SndBufN{
	Pan2 output;
	SndBufPlus buf[1];
	int chan;

	fun void init(string path,int c){
		c=>chan;
		new SndBufPlus[c]@=>buf;
		for(int i;i<buf.size();i++){
			buf[i].read(path);
			buf[i].channel(i);
			if(i%2)buf[i]=>output.right;
			else buf[i]=>output.left;
		}
	}

	fun int isConnectedTo(UGen u){
		return buf[0].isConnectedTo(u);
	}

	fun float gain(){return buf[0].gain();}
	fun float gain(float g){
		for(int i;i<chan;i++){
			buf[i].gain(g);
		}
		return buf[0].gain();
	}
	
	fun int channels(){return chan;}
	fun int channels(int c){
		c=>chan;
		return chan;
	}

	fun void read(string path){
		buf[0].read(path);
		init(path,buf[0].channels());
	}

	fun void trigger(){
		for(int i;i<buf.size();i++){
			buf[i].trigger();
		}
	}

	fun void stop(){
		for(int i;i<buf.size();i++){
			buf[i].stop();
		}
		
	}

	fun void reverse(){
		for(int i;i<buf.size();i++){
			buf[i].reverse();
		}
	}

	//------------------------|  PHASE FUNCTIONS  |------------------------
	fun float startPhase(){return buf[0].startPhs;}
	fun float startPhase(float p){
		for(int i;i<buf.size();i++){
			buf[i].startPhase(p);
		}
	}

	fun float endPhase(){return buf[0].endPhs;}
	fun float endPhase(float p){
		for(int i;i<buf.size();i++){
			buf[i].endPhase(p);
		}
	}

	fun float lengthPhase(){return buf[0].lengthPhs;}
	fun float lengthPhase(float p){
		for(int i;i<buf.size();i++){
			buf[i].lengthPhase(p);
		}
	}

	fun int startPosition(){return buf[0].startPos;}
	fun int startPosition(int p){
		for(int i;i<buf.size();i++){
			buf[i].startPosition(p);
		}
	}

	fun int endPosition(){return buf[0].endPos;}
	fun int endPosition(int p){
		for(int i;i<buf.size();i++){
			buf[i].endPosition(p);
		}
	}

	fun int lengthSamples(){return buf[0].lengthSamps;}
	fun int lengthSamples(int p){
		for(int i;i<buf.size();i++){
			buf[i].lengthSamples(p);
		}
	}

	fun dur startDuration(){return buf[0].startDur;}
	fun dur startDuration(dur d){
		for(int i;i<buf.size();i++){
			buf[i].startDuration(d);
		}
	}

	fun dur endDuration(){return buf[0].endDur;}
	fun dur endDuration(dur d){
		for(int i;i<buf.size();i++){
			buf[i].endDuration(d);
		}
	}

	fun dur lengthDuration(){return buf[0].lengthDur;}
	fun dur lengthDuration(dur d){
		for(int i;i<buf.size();i++){
			buf[i].lengthDuration(d);
		}
		return buf[0].lengthDuration();
	}

	fun int chunks(){return buf[0].chunks();}
	fun int chunks(int c){
		for(int i;i<buf.size();i++){
			buf[i].chunks(c);
		}
		return buf[0].chunks();
	}

	fun int pos(){return buf[0].pos();}
	fun int pos(int p){
		for(int i;i<buf.size();i++){
			buf[i].pos(p);
		}
		return buf[0].pos();
	}

	fun float valueAt(int b,int p){return buf[b].valueAt(p);}

	fun int loop(){return buf[0].loop();}
	fun int loop(int l){
		for(int i;i<buf.size();i++){
			buf[i].loop(l);
		}
		return buf[0].loop();
	}

	fun int interp(){return buf[0].interp();}
	fun int interp(int in){
		for(int i;i<buf.size();i++){
			buf[i].interp(in);
		}
		return buf[0].interp();
	}

	fun float rate(){return buf[0].rate();}
	fun float rate(float r){
		for(int i;i<buf.size();i++){
			buf[i].rate(r);
		}
		return buf[0].rate();
	}

	fun float play(){return buf[0].play();}
	fun float play(float r){
		for(int i;i<buf.size();i++){
			buf[i].play(r);
		}
		return buf[0].play();
	}

	fun float freq(){return buf[0].freq();}
	fun float freq(float f){
		for(int i;i<buf.size();i++){
			buf[i].freq(f);
		}
		return buf[0].freq();
	}

	fun float phase(){return buf[0].phase();}
	fun float phase(float p){
		for(int i;i<buf.size();i++){
			buf[i].phase(p);
		}
		return buf[0].phase();
	}

	fun int channel(int b){return buf[b].channel();}
	fun int channel(int b, int c){return buf[b].channel(c);}

	//	fun float phaseOffset(){return buf[b].phaseOffset();}          // these don't work in the base SndBuf class
	//	fun float phaseOffset(float o){return buf[b].phaseOffset(o);}

	fun int samples(){return buf[0].samples();}
	fun int samples(int b){return buf[b].samples();}

	fun dur length(){return buf[0].length();}

	fun int channels(int b){return buf[b].channels();}
}
