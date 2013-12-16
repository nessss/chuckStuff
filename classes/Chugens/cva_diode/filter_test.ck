SawOsc saw => CVADiodeLadderFilter diode => dac;
diode.init();
250 => diode.m_dFc;
diode.updateFilter();
diode.reset();
200 => saw.freq;

MidiIn min;
min.open("nanoKONTROL2 SLIDER/KNOB");
1.0/127.0 => float midiNorm;

spork ~ knobs(min);

while(10.1::ms => now);

fun void knobs(MidiIn min){
    MidiMsg msg;
    while(min => now){
        while(min.recv(msg)){
            if(msg.data2 == 16){
                (msg.data3*150)+30=> diode.m_dFc;
                diode.updateFilter();
                <<<"cutoff:", diode.m_dFc>>>;
                <<<"q", diode.m_dK>>>;
            }
            else if(msg.data2 == 17){
                (msg.data3*midiNorm*16)+0.1 => diode.m_dK;
                diode.updateFilter();
                <<<"cutoff:", diode.m_dFc>>>;
                <<<"q", diode.m_dK>>>;
            }
        }
    }
}