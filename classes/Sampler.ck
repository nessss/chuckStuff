public class Sampler extends Chubgraph{
	SndBuf buf[];
	LPF lpf[];
	HPF hpf[];
	BPF bpf[];

	dur lengthDur[];
	float lengthPhase[];

	fun void init(string paths[]){
		new SndBuf[paths.size()]@=>buf;
		new LPF[paths.size()]@=>lpf;
		new HPF[paths.size()]@=>hpf;
		new BPF[paths.size()]@=>bpf;
		new dur[paths.size()]@=>lengthDur;
		new float[paths.size()]@=>lengthPhase;

		for(int i;i<paths.size();i++){
			buf[i].read(paths[i]);
			buf[i].length()=>lengthDur[i];
			1.0=>lengthPhase[i];
		}
	}



	//--------------------------| FILTER FUNCTIONS |--------------------------
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
	fun void play(int b){
		spork~_play(b);
	}

	fun void _play(int b){
		if(lengthMode[b]==0){  //duration mode
			lengthDur[b]=>now;
		}else{                 //phase mode
			lengthPhase[b]*buf[b].length()=>now;
		}
		buf[b].samples()=>buf[b].pos;
	}

	fun int samples(int b){
		return buf[b].samples();
	}

	fun float pos(int b){
		return buf[b].pos();
	}

	fun float pos(int b,float p){
		return buf[b].pos(p);
	}

	fun float gain(int b){
		return buf[b].gain;
	}

	fun float gain(int b,float g){
		return buf[b].gain(g);
	}

	fun float phase(int b){
		return buf[b].phase();
	}

	fun float phase(int b,float p){
		return buf[b].phase(p);
	}

	fun float valueAt(int b,int s){
		return buf[b].valueAt(s);
	}

	fun int loop(int b){
		return buf[b].loop();
	}

	fun int loop(int b,int l){
		return buf[b].loop(b);
	}

	fun int interp(int b,int l){
		return buf.[b].interp();
	}

	fun int interp(int b,int i){
		return buf[b].interp(i);
	}

	fun float rate(int b){
		return buf[b].rate();
	}

	fun float rate(int b,float r){
		return buf[b].rate(r);
	}

	fun float freq(int b){
		return buf[b].freq();
	}

	fun float freq(int b,float f){
		return buf[b].freq(f);
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
	}

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
