public class MidiBroadcaster{
    MidiIn min;
    MidiMsg msg;
    MidiEvent mev;
    Shred loopShred;
    
    fun void init(){
    	init(0);
    }
    
    fun void init(int port){
    	min.open(port);
    	spork~loop()@=>loopShred;
    }
    
    fun void init(string portName){
    	min.open(portName);
    	spork~loop()@=>loopShred;
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
