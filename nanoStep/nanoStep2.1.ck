//       NANOSTEP 2.0 (v3)
//- A nanoKONTROL sequencer
//     for the new era!     -

0 => int drumSel;
MidiIn min;
MidiOut mout;
MidiMsg msg;
1.0/127.0 => float midiNorm;

NanoKONTROL2 nano;

8 => int numDrums;
Pan2 faderBus[numDrums];
Sampler sampler[numDrums];
RhythmSequencer rseq[numDrums];
Clock clock;

init();
while(samp=>now);


//Initializer
fun void init(){
    clock.init();
    sampler[0].init("kck");
    sampler[1].init("snr");
    sampler[2].init("snr");
    sampler[3].init("hh");
    sampler[4].init("hh");
    sampler[5].init("tom");
    sampler[6].init("tom");
    sampler[7].init("cym");
    for(int i; i<numDrums; i++){
        sampler[i].output => faderBus[i] => dac;
        rseq[i].init(sampler[i]);
        rseq[i].patLength(16);
    }
    
    mout.open("nanoKONTROL2 CTRL");
    min.open("nanoKONTROL2 SLIDER/KNOB");
    
    spork ~ nanoMidi(min);
    clearLEDs();
    spork ~ playBlink();
    spork ~ recBlink();
    midiOut(nano.button[0][0], 127);
}


//Functions

fun void recBlink(){
    OscRecv orec;
    98765 => orec.port;
    orec.listen();
    orec.event("/c, f") @=> OscEvent e;
    while(e => now){
        while(e.nextMsg() !=0){
            if(rseq[drumSel].stepIsOn(e.getFloat()$int % rseq[drumSel].pLen)){
                midiOut(nano.rec, 127);
            }
            else midiOut(nano.rec, 0);
        }
    }
}

fun void playBlink(){
    OscRecv orec;
    98765 => orec.port;
    orec.listen();
    orec.event("/c, f") @=> OscEvent e;
    while(e => now){
        while(e.nextMsg() !=0){
            if(! (e.getFloat()$int % 4)){
                midiOut(nano.ply, 127);
            }
            else midiOut(nano.ply, 0);
        }
    }
}

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
                }
            }
        }
        else if(nano.buttonRow(cc)==2){
            for(int i; i<8; i++){
                if(cc == nano.button[i][2]){
                    toggleStep(i+8);
                }
            }
        }
    }
}

fun void knobs(int cc, int val){
    if(cc==nano.knob[0]){ 
        rseq[drumSel].soundSelect((val*midiNorm*sampler[drumSel].numSounds)$int);
    }
    else if(cc==nano.knob[1]) sampler[drumSel].rate(rseq[drumSel].soundSel, val*midiNorm*2);
    else if(cc==nano.knob[2]) sampler[drumSel].gain(rseq[drumSel].soundSel, val*midiNorm);
    else if(cc==nano.knob[3]) faderBus[drumSel].pan(val*midiNorm*2-1);
    else if(cc==nano.knob[4]) sampler[drumSel].endPhase(rseq[drumSel].soundSel, val*midiNorm);
    else if(cc==nano.knob[5]){
        for(int i; i<numDrums; i++){
            rseq[i].patLength(Math.pow(2,Math.round(val*midiNorm*4))$int);
        }
    }
    else if(cc==nano.knob[6]) clock.swingAmount(val*midiNorm);
    else if(cc==nano.knob[7]) clock.tempo(val*midiNorm*180+50);
}

fun void faders(int cc, int val){
    for(int i; i<numDrums; i++){
        if(cc==nano.fader[i]){
            val*midiNorm => faderBus[i].gain;
        }
    }
}

fun void transport(int cc, int val){
    if(val){
        if(cc==nano.ply){ 
            clock.play(1);
            midiOut(nano.stp,0);
            midiOut(nano.ply,127);
        }
        else if(cc==nano.stp){ 
            clock.play(0);
            midiOut(nano.ply,0);
            midiOut(nano.rec,0);
            midiOut(nano.stp,127);
        }
        else if(cc==nano.rew) {
            for(int i; i<numDrums; i++){
                rseq[i].patEditing(0);
            }
            midiOut(nano.ffw,0);
            midiOut(nano.rew,127);
            showEditing();
        }
        else if(cc==nano.ffw){
            for(int i; i<numDrums; i++){
                rseq[i].patEditing(1);
            }
            midiOut(nano.rew,0);
            midiOut(nano.ffw,127);
            showEditing();
        }
        else if(cc==nano.cyc){
            for(int i; i<numDrums; i++){
                rseq[i].patPlaying(rseq[i].patEditing());
            }
            showEditing();
        }
    }
}

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
    if(rseq[drumSel].patEditing() != rseq[drumSel].patPlaying()) midiOut(nano.cyc, 0);
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
            if(nano.isKnob(msg.data2)){
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

fun void clearLEDs(){
    for(int i; i<8; i++){
        for(int j; j<3; j++) midiOut(nano.button[i][j], 0);
    }
    for( int i; i<nano.trans.cap(); i++) midiOut(nano.trans[i], 0);
    midiOut(nano.cyc, 0);
}
