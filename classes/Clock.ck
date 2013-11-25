//Clock
//Bruce Lott & Ness Morris 
//August 2013
public class Clock{
    int stepDiv, playing, metroOn, swingMode;
    float BPM, cStep, nSteps, swingAmt;
    dur stepLen, SPB, swing; 
    time lastStep;
    Shred loopS;
    SinOsc metro;
    ADSR metroEnv;
    OscSend locXmit;
    OscSend netXmit[0];
    int networking;
    
    
    //Functions
    fun void init(float nTempo){
        locXmit.setHost("localhost", 98765);
        1 => stepDiv;
        0 => metroOn;
        0 => swingMode;
        Math.FLOAT_MAX => nSteps;
        tempo(nTempo);
        //swingAmount(.2);
        stepDivider(4);
        play(1);
        spork ~ loop() @=> loopS;
        //Metronome
        if(metroOn){
            metro.freq(Std.mtof(60));
            metroEnv.set(1::ms, 10::ms, 0, 0::ms);
            metro => metroEnv => dac;
        }
    }
    
    fun void initNetOsc(string adr, int port){
        1 => networking;
        netXmit << new OscSend;
        netXmit[netXmit.cap()-1].setHost(adr,port);
    }
    
    fun void init(){init(120);}
    
    fun void wait(){
        if(swingMode == 0){
            if(cStep%2==0){ 
                if(now-lastStep >= stepLen + swing) incStep();
            }
            else{
                if(now-lastStep >= stepLen - swing) incStep();
            }
        }
        else if(swingMode == 1){
            if(cStep%2==0){ 
                if(now-lastStep >= stepLen - swing) incStep();
            }
            else{
                if(now-lastStep >= stepLen + swing) incStep();
            }
        }
        else if(swingMode == 2){
            if(cStep%2==0){ 
                if(now-lastStep >= stepLen) incStep();
            }
            else if(cStep%4==1){ 
                if(now-lastStep >= stepLen + swing) incStep();
            }
            else{ 
                if(now-lastStep >= stepLen - swing) incStep();
            }
        }
        else if(swingMode == 3){
            
            if(cStep%2==0){ 
                if(now-lastStep >= stepLen) incStep();
            }
            else if(cStep%4==1){
                if(now-lastStep >= stepLen + swing) incStep();
            }
            else{
                if(now-lastStep >= stepLen - swing) incStep();
            }
        }
        else if(swingMode == 4){
            if(cStep%4==0|cStep%4==1){
                if(now-lastStep >= stepLen - swing) incStep();
            }
            else if(now-lastStep >= stepLen + swing) incStep();
        }
        else if(swingMode == 5){
            if(cStep%4==0|cStep%4==1){
                if(now-lastStep >= stepLen + swing) incStep();
            }
            else if(now-lastStep >= stepLen - swing) incStep();
        }
        
        samp => now;
    }
    
    fun void incStep(){
        now => lastStep;
        if(cStep+1 < nSteps) 1 +=> cStep;
        else 0 => cStep;
        locXmit.startMsg("/c, f");
        locXmit.addFloat(cStep);
        if(networking){
            for(int i; i<netXmit.cap(); i++){
                netXmit[i].startMsg("/c, f");
                netXmit[i].addFloat(cStep);
            }
        }
        //<<<cStep>>>;
        if(metroOn){ 
            metroEnv.keyOff();
            metroEnv.keyOn();
        } 
    }
    
    //Parameters
    fun dur stepLength(){ return stepLen; }
    
    fun float swingAmount(){ return swingAmt; }
    fun float swingAmount(float s){
        unitClip(s) => swingAmt;
        stepLen * swingAmt => swing;
    }
    
    fun int metronome(){ return metroOn; }
    fun int metronome(int m){
        if(!m) 0 => metroOn;
        else 1 => metroOn;
        return metroOn;
    }
    
    fun int play(){ return playing; } 
    fun int play(int p){
        if(p){
            now => lastStep; //play/if already playing, re-cue
            0 => cStep;
            1 => playing;
            locXmit.startMsg("/c, f");
            locXmit.addFloat(cStep);
            if(networking){
                for(int i; i<netXmit.cap(); i++){
                    netXmit[i].startMsg("/c, f");
                    netXmit[i].addFloat(cStep);
                }
            }
        }
        else 0 => playing; //if p = 0, stop
        return playing;
    }
    
    fun float tempo(){ return BPM; } 
    fun float tempo(float newBPM){
        newBPM => BPM;
        60.0::second/BPM => SPB;
        stepDivider(stepDiv);
        return BPM;
    }
    
    fun float incTempo(int inc){ return tempo(BPM + inc); }
    fun float incTempo(float inc){ return tempo(BPM + inc); }
    
    fun int stepDivider() { return stepDiv; }
    fun int stepDivider(int d){
        if(d>0){
            d => stepDiv;
            SPB/stepDiv => stepLen;
            swingAmount(swingAmt);
        }
        return stepDiv;
    }
    
    fun void kill(){ loopS.exit(); }
    
    //Utilities
    fun float unitClip(float f){ //clips to 0.0-1.0
        if(f<0) return 0.0;
        else if(f>1) return 1.0;
        else return f;
    }
    
    //Loops
    fun void loop(){
        while(true){
            if(playing) wait();
            else samp => now;
        }
    }
}
