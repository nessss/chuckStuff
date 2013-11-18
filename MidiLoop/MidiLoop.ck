MidiIn min;
MidiOut mout;
MidiMsg msgs[0];
min.open("Ableton Push User Port");
mout.open("Ableton Push User Port");
time delta;
dur stopDur;
int recording;
int recordArmed;
3.779::second=>dur measure;
Event downbeat;
Shred playShred,stopShred;
0x45=>int pedal;
recordingLight(0);
spork~clockLoop();
while(min=>now){
    while(min.recv(MidiMsg newMsg)){
        if(recording){
            if(newMsg.data1==0xB0&newMsg.data2==pedal&newMsg.data3){
            	stopShred.exit();
            	spork~stop()@=>stopShred;
            }
            else{
                now-delta=>newMsg.when;
                now=>delta;
                msgs<<newMsg;
            }
        }else if(newMsg.data1==0xB0&newMsg.data2==pedal&newMsg.data3){
            chout<="Record armed..."<=IO.nl();
            spork~record();
        }
    }
}

fun void clockLoop(){
    int count;
    while(0.25::measure=>now){
        if(!count%4){
            downbeat.broadcast();
        }
        //chout<=count<=IO.nl();
        count++;
        4%=>count;
    }
}

fun void record(){
    downbeat=>now;
    chout<="Recording..."<=IO.nl();
    playShred.exit();
    msgs.clear();
    1=>recording;
    now=>delta;
    recordingLight(1);
}

fun void recordingLight(int on){
    MidiMsg msg;
    0xB0=>msg.data1;
    0x56=>msg.data2;
    if(on)
        0x7F=>msg.data3;
    else
    	0x00=>msg.data3;
    mout.send(msg);
}

fun void stop(){
    chout<="Stopping..."<=IO.nl();
    downbeat=>now;
    chout<="Stopped."<=IO.nl();
    recordingLight(0);
    playShred.exit();
    if(recording){
        0=>recording;
        now-delta=>stopDur;
        spork~play()@=>playShred;
    }
    while(samp=>now);
}


fun void play(){
    chout<="Playing..."<=IO.nl();
    while(true){
        for(int i;i<msgs.cap();i++){
            msgs[i].when=>now;
            mout.send(msgs[i]);
        }
        stopDur=>now;
    }
}
