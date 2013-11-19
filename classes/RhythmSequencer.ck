public class RhythmSequencer extends Sequencer{
    Sampler sampler;
    int soundSel;
    
    //Initializer
    fun void init(Sampler s){
        _init();
        s @=> sampler;
        0 => soundSel;
    }
    
    fun void soundSelect(int s){
        if(s>=0 & s<sampler.numSounds){
            s => soundSel;
        }
    }
    
    fun void doStep(){
        if(ons[pPlay][cStep] == 1){ 
            sampler.trigger(soundSel);
        }
    }
    
}

//TODO:
//Add gain per step