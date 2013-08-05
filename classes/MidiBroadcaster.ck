public class MidiBroadcaster{
    MidiIn min;
    MidiMsg msg;
    MidiEvent mev;
    Shred loopShred;
    
    MidiIn minCheck[16];
    
    int devices;
    
    fun void init(){
    	openMidi(0);
        spork~loop()@=>loopShred;
    }
    
    fun void init(int port){
    	openMidi(port);
    	spork~loop()@=>loopShred;
    }
    
    fun void init(string portName){
    	openMidi(portName);
    	spork~loop()@=>loopShred;
    }
    
    fun void openMidi(int port){
    	min.open(port);
    }
    
    fun void openMidi(string portName){
    	min.open(portName);
    }
    
    fun string name(){
        return min.name();
    }
    
    fun void loop(){
        while(min=>now){
            while(min.recv(msg)){
                msg@=>mev.msg;
                mev.broadcast();
            }
        }
    }
    
    fun void kill(){
        loopShred.exit();
    }
    
}