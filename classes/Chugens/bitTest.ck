SinOsc s=>BitCrush b=>dac;
//spork~printVal();
0.8=>b.gain;
200=>s.freq;

while(true){
    32=>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
    24=>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
    16=>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
    12=>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
    8 =>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
    4 =>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
    2 =>b.bits;
    <<<b.bits,"">>>;
    2::second=>now;
}

fun void printVal(){
    while(99::ms=>now){
        <<<b.last()>>>;
    }
}