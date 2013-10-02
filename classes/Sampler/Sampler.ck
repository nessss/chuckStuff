public class Sampler{
	SndBufN buf[];
	LPF lpf[];
	HPF hpf[];
	BPF bpf[];
	Pan2 output;
	string paths[0];

	fun void init(string folder){
		getPaths(folder);
		new SndBufN[paths.size()]@=>buf;
		new LPF[paths.size()]@=>lpf;
		new HPF[paths.size()]@=>hpf;
		new BPF[paths.size()]@=>bpf;

		for(int i;i<paths.size();i++){
			buf[i].read(paths[i]);
			setFilter(i,"none");
		}
	}



	fun string[] getPaths(string folder){
		string paths[0];
		FileIO fio;
		fio.open(me.dir()+"/data/"+folder+"/samplePaths.txt",FileIO.READ);
		while(fio.more()){
			fio.readLine()=>string line;
			if(line!=""){
				me.dir()+"/data/"+line=>line;
				paths<<line;
			}
		}
		return paths;
	}

	//--------------------------| FILTER FUNCTIONS |--------------------------

	fun FilterBasic connectedFilter(int b){
		if(buf[b].isConnectedTo(lpf[b])){
			return lpf[b];
		}else if(buf[b].isConnectedTo(hpf[b])){
			return hpf[b];
		}else if(buf[b].isConnectedTo(bpf[b])){
			return bpf[b];
		}
		return new FilterBasic;
	}

	fun void setFilter(int b,string f){
		buf[b].output=<connectedFilter(b)=<output;
		buf[b].output=<output;
		if(f=="LPF"){
			buf[b].output=>lpf[b]=>output;
		}else if(f=="HPF"){
			buf[b].output=>hpf[b]=>output;
		}else if(f=="BPF"){
			buf[b].output=>bpf[b]=>output;
		}else if(f=="none"){
			buf[b].output=>output;
		}
	}



	fun float filterFreq(int b){
		return connectedFilter(b).freq();
	}

	fun float filterFreq(int b,float f){
		return connectedFilter(b).freq(f);
	}

	fun float filterQ(int b){
		return connectedFilter(b).Q();
	}

	fun float filterQ(int b,float q){
		return connectedFilter(b).Q();
	}

	//--------------------------| SNDBUF FUNCTIONS |--------------------------

	fun void trigger(int b){buf[b].trigger();}

	fun int samples(int b,int s){return buf[b].samples(s);}

	fun int[] samplesAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].samples(s)=>results[i];
		return results;
	}

	fun int pos(int b,int s){return buf[b].pos(s);}
	fun int pos(int b,int p,int s){return buf[b].pos(s,p);}

	fun int[] posAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].pos(s)=>results[i];
		return results;
	}

	fun float gain(int b){return buf[b].gain();}
	fun float gain(int b,float g){return buf[b].gain(g);}

	fun float[] gainAll(int b,int s){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].gain(s)=>results[i];
		return results;
	}

	fun float phase(int b,int s){return buf[b].phase(s);}
	fun float phase(int b,float p,int s){return buf[b].phase(s,p);}

	fun float[] phaseAll(int b,int s){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].phase(s)=>results[i];
		return results;
	}

	fun float valueAt(int b,int s,int sample){return buf[b].valueAt(sample,s);}

	fun int loop(int b,int s){return buf[b].loop(s);}
	fun int loop(int b,int l,int s){return buf[b].loop(s,l);}

	fun int[] loopAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].loop(s)=>results[i];
		return results;
	}

	fun int interp(int b,int s){return buf[b].interp(s);}
	fun int interp(int b,int i,int s){return buf[b].interp(s,i);}

	fun int[] interpAll(int b,int s){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].interp(s)=>results[i];
		return results;
	}

	fun float rate(int b,int s){return buf[b].rate(s);}
	fun float rate(int b,float r,int s){return buf[b].rate(s,r);}

	fun float[] rateAll(int b,int s){
		float results[buf.size(s)];
		for(int i;i<results.size();i++)buf[i].rate(s)=>results[i];
		return results;
	}

	fun float freq(int b,int s){return buf[b].freq(s);}
	fun float freq(int b,float f,int s){return buf[b].freq(s,f);}

	fun float[] freqAll(int b,int s){
		float results[buf.size(s)];
		for(int i;i<results.size();i++)buf[i].freq(s)=>results[i];
		return results;
	}

	//--------------------------| LENGTH FUNCTIONS |--------------------------

}
