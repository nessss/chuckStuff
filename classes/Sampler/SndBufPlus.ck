public class SndBufPlus extends Chubgraph{
	SndBuf buf=>outlet;

	dur startDur;
	dur endDur;
	dur lengthDur;

	float startPhs;
	float endPhs;
	float lengthPhs;

	int startPos;
	int endPos;
	int lengthSamps;
    
    int voices;

	Event done;

	fun void init(){
		0::samp=>startDur;
		length()=>endDur=>lengthDur;

		0=>startPhs;
		1=>endPhs=>lengthPhs;

		0=>startPos;
		samples()=>endPos=>lengthSamps;
	}

	//------------------------| TRIGGER FUNCTIONS |------------------------
	fun void trigger(){
		spork~_trigger();
	}

	fun void _trigger(){
        voices++;
		pos(startPos);
		lengthDur=>now;
        voices--;
        if(voices==0){
            stop();
            done.broadcast();
        }
	}

	fun void stop(){
		buf.gain()=>float beginGain;
		for(int i;i<100;i++){
			buf.gain()-beginGain/100=>buf.gain;
			samp=>now;
		}
			
		if(rate()>0){
			pos(buf.samples());
		}else{
			pos(0);
		}
		beginGain=>buf.gain;
	}

	fun void reverse(){
		rate(-1.0*rate());
		startPhs=>float tempPhs;
		endPhs=>startPhs;
		tempPhs=>endPhs;
		_phaseToDur();
		_phaseToPos();
	}

	//------------------------|  PHASE FUNCTIONS  |------------------------
	fun float startPhase(){return startPhs;}
	fun float startPhase(float p){
		unitClip(p)=>startPhs;
		endPhs-startPhs=>lengthPhs;
		_phaseToDur();
		_phaseToPos();
	}

	fun float endPhase(){return endPhs;}
	fun float endPhase(float p){
		unitClip(p)=>endPhs;
		endPhs-startPhs=>lengthPhs;
		_phaseToDur();
		_phaseToPos();
	}

	fun float lengthPhase(){return lengthPhs;}
	fun float lengthPhase(float p){
		unitClip(p)=>p;
		p=>lengthPhs;
		unitClip(startPhs+lengthPhs)=>endPhs;
		_phaseToDur();
		_phaseToPos();
	}

	fun void _phaseToDur(){
		startPhs*length()=>startDur;
		endPhs*length()=>endDur;
		lengthPhs*length()=>lengthDur;
	}

	fun void _phaseToPos(){
		(startPhs*samples())$int=>startPos;
		(endPhs*samples())$int=>endPos;
		(lengthPhs*samples())$int=>lengthSamps;
	}

	//------------------------| DURATION FUNCTIONS |------------------------
	fun dur startDuration(){return startDur;}
	fun dur startDuration(dur d){
		if(d>length())length()=>d;
		d=>startDur;
		endDur-startDur=>lengthDur;
		_durToPhase();
		_durToPos();
	}

	fun dur endDuration(){return endDur;}
	fun dur endDuration(dur d){
		if(d>length())length()=>d;
		d=>endDur;
		endDur-startDur=>lengthDur;
	}

	fun dur lengthDuration(){return lengthDur;}
	fun dur lengthDuration(dur d){
		if(d>length())length()=>d;
		d=>lengthDur;
		startDur+lengthDur=>endDur;
	}

	fun void _durToPhase(){
		length()/startDur=>startPhs;
		length()/endDur=>endPhs;
		length()/lengthDur=>lengthPhs;
	}

	fun void _durToPos(){
		(startDur/samp)$int=>startPos;
		(endDur/samp)$int=>endPos;
		(lengthDur/samp)$int=>endPos;
	}

	//------------------------| POS FUNCTIONS |------------------------
	fun int startPosition(){return startPos;}
	fun int startPosition(int p){
		unitClip(p,0,samples());
		p=>startPos;
		_posToPhs();
		_posToDur();
	}

	fun int endPosition(){return endPos;}
	fun int endPosition(int p){
		unitClip(p,0,samples());
		p=>endPos;
		_posToPhs();
		_posToDur();
	}

	fun int lengthSamples(){return lengthSamps;}
	fun int lengthSamples(int l){
		unitClip(l,0,samples());
		l=>lengthSamps;
		_posToPhs();
		_posToDur();
	}

	fun void _posToPhs(){
		startPos$float/samples()$float=>startPhs;
		endPos$float/samples()$float=>endPhs;
		lengthSamps$float/samples()$float=>lengthPhs;
	}

	fun void _posToDur(){
		startPos::samp=>startDur;
		endPos::samp=>endDur;
		lengthSamps::samp=>lengthDur;
	}

	//------------------------| SNDBUF FUNCTIONS |------------------------
	fun void read(string path){
		buf.read(path);
		init();
	}

	fun int chunks(){return buf.chunks();}
	fun int chunks(int c){return buf.chunks(c);}

	fun int pos(){return buf.pos();}
	fun int pos(int p){return buf.pos(p);}

	fun float valueAt(int p){return buf.valueAt(p);}

	fun int loop(){return buf.loop();}
	fun int loop(int l){return buf.loop(l);}

	fun int interp(){return buf.interp();}
	fun int interp(int i){return buf.interp(i);}

	fun float rate(){return buf.rate();}
	fun float rate(float r){return buf.rate(r);}

	fun float play(){return buf.play();}
	fun float play(float r){return buf.play(r);}

	fun float freq(){return buf.freq();}
	fun float freq(float f){return buf.freq(f);}

	fun float phase(){return buf.phase();}
	fun float phase(float p){return buf.phase(p);}

	fun int channel(){return buf.channel();}
	fun int channel(int c){return buf.channel(c);}

	//	fun float phaseOffset(){return buf.phaseOffset();}          // these don't work in the base SndBuf class
	//	fun float phaseOffset(float o){return buf.phaseOffset(o);}

	fun int samples(){return buf.samples();}

	fun dur length(){return buf.length();}

	fun int channels(){return buf.channels();}

	//------------------------|     UNIT CLIP    |------------------------
	fun float unitClip(float a,float min,float max){
		if(a<min)min=>a;
		if(a>max)max=>a;
		return a;
	}

	fun float unitClip(float a){
		return unitClip(a,0,1);
	}

	//------------------------|     NORMALIZE    |-----------------------
	fun float gain(){return buf.gain();}
	fun float gain(float g){return buf.gain(g);}

	fun void normalize(){
		float max;
		for(int i;i<samples();i++){
			if(buf.valueAt(i)>max)buf.valueAt(i)=>max;
		}
		buf.gain(1.0/max);
	}
}
