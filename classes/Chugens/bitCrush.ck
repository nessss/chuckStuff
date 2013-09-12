public class bitCrush extends Chugen{
	32=>int _bits;
	if(bits==0)2=>bits;
	while(bits!&0x80000000)1<<=>bits;
	fun float tick(float in){
		return in&bitMask;
	}
}
