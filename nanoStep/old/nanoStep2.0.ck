//       NANOSTEP 2.0 (v3)
//- A nanoKONTROL sequencer
//     for the new era!     -

0 => int drumSel;
MidiIn min;
MidiOut mout;
MidiMsg msg;

2 => int numDrums;
Pan2 faderBus[numDrums];
NanoKONTROL2 nano;
Sampler sampler[numDrums];
RhythmSequencer rseq[numDrums];
Clock clock;

init();
while(samp=>now);


//Initializer
fun void init(){
    clock.init();
    sampler[0].init("kck");
    sampler[0].output => dac;
    sampler[1].init("snr");
    sampler[1].output => dac;
    for(int i; i<numDrums; i++){
        sampler[i] => faderBus[i] => dac;
    }
    /*
    sampler[1].init("snr");
    sampler[2].init("snr");
    sampler[3].init("hh");
    sampler[4].init("hh");
    sampler[5].init("tom");
    sampler[6].init("tom");
    sampler[7].init("cym");
    for(int i; i<numDrums; i++){
        sampler[i].output => knobBus[i];
        knobBus[i] => dac;
        rseq[i].init(sampler[i]);
        rseq[i].patLength(16);
    }
    */
    rseq[0].init(sampler[0]);
    rseq[0].patLength(16);
    rseq[1].init(sampler[1]);
    rseq[1].patLength(16);
    
    mout.open("nanoKONTROL2 CTRL");
    min.open("nanoKONTROL2 SLIDER/KNOB");
    spork ~ nanoMidi(min);
}


//Functions

fun void toggleStep(int s){
    rseq[drumSel].toggleStepOn(s);
    updateStep(s);
}

fun void updateStep(int s){
    if(s<8) midiOut(nano.button[s%8][1], rseq[drumSel].stepIsOn(s)*127);
    else midiOut(nano.button[s%8][2], rseq[drumSel].stepIsOn(s)*127);
}

fun void buttons(int cc, int val){
    if(val){
        <<<nano.buttonRow(cc)>>>;
        if(nano.buttonRow(cc) == 0){
            for(int i; i<8; i++){      
                if(cc == nano.button[i][0]){ 
                    drumSelect(i);
                }
            }
        }
        else if(nano.buttonRow(cc)==1){
            for(int i; i<8; i++){
                if(cc == nano.button[i][1]){
                    toggleStep(i);
                    <<<i>>>;
                }
            }
        }
        else if(nano.buttonRow(cc)==2){
            for(int i; i<8; i++){
                if(cc == nano.button[i][2]){
                    toggleStep(i+8);
                    <<<i+8>>>;
                }
            }
        }
    }
}

fun void knobs(int cc, int val){
    if(cc==nano.knob[0])
}

fun void faders(int cc, int val){
    for(int i; i<numDrums; i++){
        
    }
}
fun void transport(int cc, int val){}

fun void drumSelect(int d){
    midiOut(nano.button[drumSel][0], 0);
    d => drumSel;
    midiOut(nano.button[drumSel][0], 127);
    showEditing();
}

fun void patEditing(int p){
    if(p>=0 & p<8){
        for(int i; i<numDrums; i++){
            rseq[i].patEditing(p);
        }
        showEditing();
    }
}

fun void showEditing(){
    if(rseq[drumSel].patEditing != rseq[drumSel].patPlaying) midiOut(nano.cyc, 0);
    else midiOut(nano.cyc, 127);
    //Updates step LEDs
    for(int i; i<rseq[0].patLength(); i++){
        updateStep(i);
    }
}

fun void nanoMidi(MidiIn theMin){ //pass midi to functions
    MidiMsg msg;
    while(true){
        theMin => now;
        while(theMin.recv(msg)){
            if(nano.isFader(msg.data2)){
                knobs(msg.data2, msg.data3);
            }
            else if(nano.isFader(msg.data2)){
                faders(msg.data2, msg.data3);
            }
            else if(nano.isButton(msg.data2)){
                buttons(msg.data2, msg.data3);
            }
            else if(nano.isTransport(msg.data2)){
                transport(msg.data2, msg.data3);
            }
        }
    }
}

fun void midiOut(int d2, int d3){
    0xB0 => msg.data1;
    d2   => msg.data2;
    d3   => msg.data3;
    mout.send(msg);
}
