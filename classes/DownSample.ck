public class DownSample extends Chugen{
	2=>int factor;
	0=>int sampleCount;
	0=>float nextSample;

	fun float tick(float in){
		if(sampleCount==0)in=>nextSample;
		sampleCount++;
		factor%=>sampleCount;
		return nextSample;
	}
}
