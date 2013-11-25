public class Sampler{
    SndBufN buf[];
    LPF lpf[];
    HPF hpf[];
    BPF bpf[];
    Pan2 dry[];
    int voices[];
    Pan2 output;
    string paths[0];
    int numSounds;
    Shred triggerShred[];
    int chucked[];
    
    fun void init(string folder){
        getPaths(folder)@=>paths;
        new SndBufN[paths.size()]@=>buf;
        new LPF[paths.size()]@=>lpf;
        new HPF[paths.size()]@=>hpf;
        new BPF[paths.size()]@=>bpf;
        new Pan2[paths.size()]@=>dry;
        new int[paths.size()]@=>voices;
        new Shred[paths.size()]@=>triggerShred;
        new int[paths.size()]@=>chucked;
        
        for(int i;i<paths.size();i++){
            buf[i].read(paths[i]);
            buf[i].pos(buf[i].samples());
            buf[i].output=>dry[i];
        }
        paths.cap()=>numSounds;
    }
    
    
    
    fun string[] getPaths(string folder){
        string paths[0];
        FileIO fio;
        fio.open(me.dir()+"/samplePaths.txt",FileIO.READ);
        while(fio.more()){
            fio.readLine()=>string line;
            if(line!=""){
                if(RegEx.match(folder, line)||(folder=="")){
                    paths<<me.dir()+line.substring(1);
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
    
    fun UGen connectedUGen(int b){
        if(buf[b].output.isConnectedTo(dry[b])){
            //chout<="I'm dry!"<=IO.nl();
            return dry[b];
        }
        return dry[b];
        return connectedFilter(b);
    }
    
    fun void setFilter(int b,string f){
        buf[b].output=<connectedUGen(b);
        if(f=="LPF"){
            buf[b].output=>lpf[b];
        }else if(f=="HPF"){
            buf[b].output=>hpf[b];
        }else if(f=="BPF"){
            buf[b].output=>bpf[b];
        }else if(f=="none"){
            buf[b].output=>dry[b];
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
    
    fun void trigger(int b){
    	//triggerShred[b].exit();
    	spork~_trigger(b);//@=>triggerShred[b];
    }
    
    fun void _trigger(int b){
    	//chout<=buf[b].gain()<=IO.nl();
    	//chout<=chucked[b]<=" "<=voices[b]<=IO.nl();
    	if(chucked[b]){
    		buf[b].stop();
    		100::samp=>now;
    	}
        if(!chucked[b]){
        	//chout<="chucking"<=IO.nl();
        	connectedUGen(b)=>output;
       		1=>chucked[b];
       	}
        voices[b]++;
        buf[b].trigger();
        //chout<=buf[b].lengthDuration()/second<=IO.nl();
        buf[b].lengthDuration()=>now;
        //buf[b].done=>now;
    	voices[b]--;
        stop(b);
    }
    
    fun int isPlaying(int b){
        if(voices[b])return 1;
        return 0;
    }
    
    fun void stop(int b){
    	if(isPlaying(b)){
        	//chout<="decrement "<=voices[b]<=IO.nl();
        	//triggerShred[b].exit();
        	buf[b].done.broadcast();
        	//0=>voices[b];
        	100::samp=>now;
        	if(voices[b]<=0 & chucked[b]){
        		//chout<="unchucking"<=IO.nl();
    			buf[b].stop();
    			100::samp=>now;
    			if(!voices[b]){
        			connectedUGen(b)=<output;
        			0=>chucked[b];
        		}
        	}
        }
    }

    fun void choke(int b){
    	buf[b].stop();
        //triggerShred[b].exit();
        buf[b].done.broadcast();
        //0=>voices[b];
        100::samp=>now;
        if(chucked[b]){
        	//chout<="unchucking"<=IO.nl();
        	connectedUGen(b)=<output;
        	0=>chucked[b];
        }
    }

    
    fun float pitch(int b,float s){
        return rate(b,Std.mtof(s)/Std.mtof(60.0));
    }
    
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
