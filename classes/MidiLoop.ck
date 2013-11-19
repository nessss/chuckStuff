public class MidiLooper{
    
    MidiMsg msgs[0];
    OscRecv orec;
    orec.event("/c,f")@=>OscEvent clockEvent;
    time delta;
    dur stopDur;
    int recording;
    int recordArmed;
    Shred playShred,stopShred;
    Event msgReady;
    MidiMsg curMsg;
    
    fun void init(){
        orec.port(98765);
        orec.listen();
    }
    
    fun void addMsg(MidiMsg msg){
        if(recording){
            now-delta=>msg.when;
            now=>delta;
            msgs<<msg;
        }
    }
    
    fun void record(){
        spork~_record();
    }
    
    fun void _record(){
        downbeat();
        chout<="Downbeat reached..."<=IO.nl();
        playShred.exit();
        msgs.clear();
        1=>recording;
        now=>delta;
    }
    
    fun void downbeat(){
        clockEvent=>now;
        while(clockEvent.nextMsg()){
            if(clockEvent.getFloat()$int%4){
                downbeat();
            }
        }
    }
    
    fun void stop(){
        stopShred.exit();
        spork~_stop()@=>stopShred;
    }
    
    fun void _stop(){
        downbeat();
        playShred.exit();
        if(recording){
            0=>recording;
            now-delta=>stopDur;
            chout<="Playing..."<=IO.nl();
            spork~play()@=>playShred;
        }
        while(samp=>now);
    }
    
    
    fun void play(){
        while(true){
            for(int i;i<msgs.cap();i++){
                msgs[i].when=>now;
                msgs[i]@=>curMsg;
                msgReady.broadcast();
            }
            stopDur=>now;
        }
    }
}