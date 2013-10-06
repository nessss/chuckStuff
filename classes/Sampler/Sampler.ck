public class Sampler{
	SndBufN buf[];
	LPF lpf[];
	HPF hpf[];
	BPF bpf[];
	Pan2 output;
	string paths[0];

	fun void init(string folder){
		getPaths(folder)@=>paths;
		new SndBufN[paths.size()]@=>buf;
		new LPF[paths.size()]@=>lpf;
		new HPF[paths.size()]@=>hpf;
		new BPF[paths.size()]@=>bpf;

		for(int i;i<paths.size();i++){
			buf[i].read(paths[i]);
			buf[i].pos(buf[i].samples());
			setFilter(i,"none");
		}
	}



	fun string[] getPaths(string folder){
		string paths[0];
		FileIO fio;
		fio.open(me.dir()+"/samplePaths.txt",FileIO.READ);
		while(fio.more()){
			fio.readLine()=>string line;
			if(line!=""){
				if(RegEx.match(folder, line)||(folder=="")){
					paths<<line;
				}
			}
		}
		return paths;
	}

	fun string getKit(int p){
		string matches[0];
		RegEx.match("/data/([0-9a-zA-Z]+)/",paths[p],matches);
		if(matches.size()>1)return matches[1];
		return "";
	}

	fun string getName(int p){
		string matches[0];
		RegEx.match("/data/[0-9a-zA-Z]+/[0-9a-zA-Z]+/([0-9a-zA-Z]+)",paths[p],matches);
		if(matches.size()>1)return matches[1];
		return "";
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

	fun int pos(int b){return buf[b].pos();}
	fun int pos(int b,int p){return buf[b].pos(p);} 
	fun int[] posAll(int b){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].pos()=>results[i];
		return results;
	}

	fun float gain(int b){return buf[b].gain();}
	fun float gain(int b,float g){return buf[b].gain(g);}

	fun float[] gainAll(int b){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].gain()=>results[i];
		return results;
	}

	fun float phase(int b){return buf[b].phase();}
	fun float phase(int b,float p){return buf[b].phase(p);}

	fun float[] phaseAll(int b){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].phase()=>results[i];
		return results;
	}

	fun float valueAt(int b,int sample,int s){return buf[b].valueAt(s,sample);}

	fun int loop(int b){return buf[b].loop();}
	fun int loop(int b,int l){return buf[b].loop(l);}

	fun int[] loopAll(int b){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].loop()=>results[i];
		return results;
	}

	fun int interp(int b){return buf[b].interp();}
	fun int interp(int b,int i){return buf[b].interp(i);}

	fun int[] interpAll(int b){
		int results[buf.size()];
		for(int i;i<results.size();i++)buf[i].interp()=>results[i];
		return results;
	}

	fun float rate(int b){return buf[b].rate();}
	fun float rate(int b,float r){return buf[b].rate(r);}

	fun float[] rateAll(int b){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].rate()=>results[i];
		return results;
	}

	fun float freq(int b){return buf[b].freq();}
	fun float freq(int b,float f){return buf[b].freq(f);}

	fun float[] freqAll(int b){
		float results[buf.size()];
		for(int i;i<results.size();i++)buf[i].freq()=>results[i];
		return results;
	}

	//--------------------------| LENGTH FUNCTIONS |--------------------------

}
