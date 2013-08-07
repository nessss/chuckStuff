public class Foldback extends Chugen{
    0.6 => float thresh;
    2.0 => float index;
    
    fun float tick(float in){
        0=>float out;
        1.0/thresh=>gain;
        in=>out;
        Math.sgn(in)=>float sgn;
        while(out>thresh)index*(out-thresh)-=>out;}
        while(out<(-1.0*thresh)){index*(out+thresh)-=>out;}
        return out;
    }
}