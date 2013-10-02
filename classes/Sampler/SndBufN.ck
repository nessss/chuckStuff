public class SndBufN{
	Pan2 output;
	SndBufPlus buf[1];
	int chan;

	fun void init(string path,int c){
		c=>chan;
		new SndBufPlus[c]@=>buf;
		for(int i;i<buf.size();i++){
			<<<buf[i].read(path)>>>;
			<<<buf[i].channel(i)>>>;
			if(i%2)buf[i]=>output.right;
			else buf[i]=>output.left;
		}
		<<<buf.size()>>>;
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
	}
	fun int chunks(int b){return buf[b].chunks();}
	fun int chunks(int b,int c){return buf[b].chunks(c);}

	fun int pos(int b){return buf[b].pos();}
	fun int pos(int b,int p){return buf[b].pos(p);}

	fun float valueAt(int b,int p){return buf[b].valueAt(p);}

	fun int loop(int b){return buf[b].loop();}
	fun int loop(int b,int l){return buf[b].loop(l);}

	fun int interp(int b){return buf[b].interp();}
	fun int interp(int b,int i){return buf[b].interp(i);}

	fun float rate(int b){return buf[b].rate();}
	fun float rate(int b,float r){return buf[b].rate(r);}

	fun float play(int b){return buf[b].play();}
	fun float play(int b,float r){return buf[b].play(r);}

	fun float freq(int b){return buf[b].freq();}
	fun float freq(int b,float f){return buf[b].freq(f);}

	fun float phase(int b){return buf[b].phase();}
	fun float phase(int b,float p){return buf[b].phase(p);}

	fun int channel(int b){return buf[b].channel();}
	fun int channel(int b,int c){return buf[b].channel(c);}

	//	fun float phaseOffset(){return buf[b].phaseOffset();}          // these don't work in the base SndBuf class
	//	fun float phaseOffset(float o){return buf[b].phaseOffset(o);}

	fun int samples(int b){return buf[b].samples();}

	fun dur length(int b){return buf[b].length();}

	fun int channels(int b){return buf[b].channels();}
}
