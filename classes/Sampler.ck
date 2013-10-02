public class Sampler extends Chubgraph{
	SndBufN buf[];
	LPF lpf[];
	HPF hpf[];
	BPF bpf[];

	fun void init(string paths[]){
		new SndBufN[paths.size()]@=>buf;
		new LPF[paths.size()]@=>lpf;
		new HPF[paths.size()]@=>hpf;
		new BPF[paths.size()]@=>bpf;

		for(int i;i<paths.size();i++){
			buf[i].read(paths[i]);
			buf[i].length()=>lengthDur[i];
			1.0=>endPhase[i];
			setFilter(i,"none");
		}
	}

	//--------------------------| FILTER FUNCTIONS |--------------------------

	fun Filter connectedFilter(int b){
		if(buf[b].isConnectedTo(lpf[b])){
			return lpf[b];
		}else if(buf[b].isConnectedTo(hpf[b])){
			return hpf[b];
		}else if(buf[b].isConnectedTo(bpf[b])){
			return bpf[b];
		}
		return new Filter;
	}

	fun void setFilter(int b,string f){
		buf[b]=<connectedFilter(buf[b])=<outlet;
		buf[b]=<outlet;
		if(f=="LPF"){
			buf[b]=>lpf[b]=>outlet;
		}else if(f=="HPF"){
			buf[b]=>hpf[b]=>outlet;
		}else if(f=="BPF"){
			but[b]=>bpf[b]=>outlet;
		}else if(f=="none"){
			buf[b]=>outlet;
		}
	}



	fun float filterFreq(int b){
		return connectedFilter(buf[b]).freq();
	}

	fun float filterFreq(int b,float f){
		return connectedFilter(buf[b]).freq(f);
	}

	fun float filterQ(int b){
		return connectedFilter(buf[b]).Q();
	}

	fun float filterQ(int b,float q){
		return connectedFilter(buf[b]).Q();
	}

	//--------------------------| SNDBUF FUNCTIONS |--------------------------

	fun void trigger(int b){buf[b].trigger();}

	fun int samples(int b){return buf[b].samples();}

	fun int[] samplesAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].samples()=>results[i];
		return results[];
	}

	fun float pos(int b){return buf[b].pos();}
	fun float pos(int b,int p){return buf[b].pos();}

	fun int[] posAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].pos()=>results[i];
		return results[];
	}
	
	fun float gain(int b){return buf[b].gain();}
	fun float gain(int b,float g){return buf[b].gain(g);}
	
	fun float[] gainAll(int b,int s){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].gain()=>results[i];
		return results[];
	}

	fun float phase(int b){return buf[b].phase();}
	fun float phase(int b,float p){return buf[b].phase();}

	fun float[] phaseAll(int b,int s){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].phase()=>results[i];
		return results[];
	}

	fun float valueAt(int b,int s){return buf[b].valueAt(s);}

	fun int loop(int b){return buf[b].loop();}
	fun int loop(int b,int l){return buf[b].loop(l);}

	fun int[] loopAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].loop()=>results[i];
		return results[];
	}

	fun int interp(int b){return buf.[b].interp();}
	fun int interp(int b,int i){return buf.[b].interp(i);}

	fun int[] interpAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].interp()=>results[i];
		return results[];
	}

	fun float rate(int b){return buf[b].rate();}
	fun float rate(int b,float r){return buf[b].rate(r);}

	fun float[] rateAll(int b,int s){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].rate()=>results[i];
		return results[];
	}

	fun float freq(int b){return buf[b].freq();}
	fun float freq(int b,float f){return buf[b].freq(f);}

	fun float[] freqAll(int b,int s){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].freq()=>results[i];
		return results[];
	}

	//--------------------------| LENGTH FUNCTIONS |--------------------------

	fun void lengthMode(int b,string m){
		if(m=="dur"){
			0=>lengthMode;  //duration mode
		}else{             
			1=>lengthMode;  //phase mode
		}
	}

	fun dur playDur(int b){
		return lengthDur[b];
	

	fun dur playDur(int b,dur d){
		if(d>buf[b].length()){
			buf[b].length()=>lengthDur[b];
		}else{
			d=>lengthDur[b];
		}
		return lengthDur[b];
	}

	fun float playPhase(int b){
		return lengthPhase[b]; 
	}

	fun float playPhase(int b,float p){
		if(p>1)1=>p;
		if(p<0)0=>p;
		p=>lengthPhase[b];
		return lengthPhase[b];
	}
}
