public class MidiLooper{
    
    MidiMsg msgs[0];
    OscRecv orec;
    orec.event("/c,f")@=>OscEvent clockEvent;
    8=>int clockDiv;
    time delta;
    dur stopDur;
    int recording;
    int recordArmed;
    int muted;
    Shred playShred,stopShred, blinkRecShred;
    MidiEvent curMsg;
    MidiOut mout;
    
    
    fun void init(){
        orec.port(98765);
        orec.listen();
    }
    
    fun void initControlButtons(MidiBroadcaster mB, MidiOut mout, int cc1, int cc2, int cc3){
        initRecButton(mB, mout, cc1);
        initClrButton(mB, mout, cc2);
        initMuteButton(mB, mout, cc3);
    }

    fun void initRecButton(MidiBroadcaster mB, MidiOut mout, int cc){
        spork~recButton(mB, mout, cc);
    }    
    
    fun void initClrButton(MidiBroadcaster mB, MidiOut mout, int cc){
        spork~clrButton(mB, mout, cc);
    }
    
    fun void initMuteButton(MidiBroadcaster mB, MidiOut mout, int cc){
        spork~muteButton(mB, mout, cc);
    }
    
    fun void recButton(MidiBroadcaster mB, MidiOut mout, int cc){
        MidiMsg msg;
        while(mB.mev=>now){
            mB.mev.msg @=> msg;
            <<<msg.data2>>>;
            if(msg.data2 == cc){
                if(recording){
                    stop();
                    blinkRecShred.exit();
                    
                }
                else{ 
                    record();
                    blinkRecShred.exit();
                    spork ~ blinkRec(mout,cc) @=> blinkRecShred;
                }
            }
        }
    }    
    
    fun void blinkRec(MidiOut mout, int cc){
        MidiMsg msg;
        144=>msg.data1;
        cc=>msg.data2;
        while(true){
            100 => msg.data3;
            mout.send(msg);
            100::ms=>now;
            0 => msg.data3;
            100::ms=>now;
        }
    }
    
    fun void clrButton(MidiBroadcaster mB, MidiOut mout, int cc){
        MidiMsg msg;
        while(mB.mev=>now){
            mB.mev.msg @=> msg;
            if(msg.data2 == cc){
                if(msg.data3>0){
                    clear();
                    mout.send(msg);
                }
                else{ 
                    mout.send(msg);
                }
            }
        }
    }    
    
    fun void muteButton(MidiBroadcaster mB, MidiOut mout, int cc){
        MidiMsg msg;
        int onClr;
        int offClr;
        
        while(mB.mev=>now){
            mB.mev.msg @=> msg;
            if(msg.data2 == cc){
                mute();
                if(muted){
                    onClr => msg.data3;
                    mout.send(msg);
                }
                else{ 
                    offClr => msg.data3;
                    mout.send(msg);
                }
            }
        }
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
    
    fun void clear(){
        stop();
        msgs.clear();
        0=>recording;
    }
    
    fun int mute(){return muted;}
    fun int mute(int m){
        if(m)1=>muted;
        else 0=>muted;
        return muted;
    }
    
    fun void downbeat(){
        clockEvent=>now;
        while(clockEvent.nextMsg()){
            if(clockEvent.getFloat()$int%clockDiv){
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
                msgs[i]@=>curMsg.msg;
                if(!muted){
                    curMsg.broadcast();
                }
            }
            stopDur=>now;
        }
    }
}
