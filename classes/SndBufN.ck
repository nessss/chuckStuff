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
}
