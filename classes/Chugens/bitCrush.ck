public class BitCrush extends Chugen{
    32=>int bits;
    Math.pow(2,63)-1=>float INT_MAX;
    
    1.0/INT_MAX=>float INV_MAX;
    
    fun float tick(float in){
        (in*INT_MAX)$int=>int val;
        (64-bits)>>=>val;
        if(maybe)1+=>val;
        (64-bits)<<=>val;
        return val*INV_MAX;
    }
}
