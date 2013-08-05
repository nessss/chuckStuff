public class Warper{
	WarpTable w;
	Envelope e;
	float value;
	float wCoefs[2];
	dur d;
	
	fun void init(){
		e=>blackhole;
		0=>val;
		1.0=>wCoefs[0];
		1.0=>wCoefs[1];
		w.coefs([wCoefs[0],wCoefs[1]]);
	}
	
	fun void trigger(){
		spork~pTrig();
	}
	
	fun void trigger(dur nD){
		nD=>d;
		e.duration(d);
		spork~pTrig();
	}
	
	private void pTrig(){
		0.0=>value=>e.value;
		e.keyOn();
		while(samp=>now){
			w.lookup(e.value())=>value;
			if(e.value()==1.0)break;
		}
	}
	
	fun dur duration(){return d;}
	fun dur duration(dur nd){
		nd=>this.d;
		e.duration(d);
		return d;
	}
	
	fun float val(){return value;}
	fun float val(float nVal){
		if(nVal>1.0)1.0=>nVal;
		if(nVal<0.0)0.0=>nVal;
		nVal=>val;
		return value;
	}
	
	fun float asymCoef(){return w.coefs[0];}
	fun float asymCoef(float nAsym){
		nAsym=>wCoefs[0];
		w.coefs([wCoefs[0],wCoefs[1]]);
		return wCoefs[0];
	}
	
	fun float symCoef(){return w.wCoefs()[1];}
	fun float symCoef(float nSym){
		nSym=>wCoefs[1];
		w.coefs([wCoefs[0],wCoefs[1]]);
		return wCoefs[1];
	}
	
	fun float[] coefs(){return wCoefs;}
	fun float[] coefs(float nCoefs[]){
		if(nCoefs.cap()==2){
			nCoefs@=>wCoefs;
		}
		return wCoefs;
	}
	
}