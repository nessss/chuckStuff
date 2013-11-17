public class ZeroDelay extends Chugen{
	
	(second/samp)=>float SAMPLE_RATE;
	(Math.PI/SAMPLE_RATE)=>float SREC;
	float s;
	float g;
	
	fun float tick(float in){
		float result;
		(g*in)+s=>result;
		BilinearTransform(in-result)=>s;
		return result;
	}

	fun float BilateralTransform(float in){
		g*in+(s+(g*in))=>s;
		return s;
	}

	fun void freq(float f){
		Math.max(0,f)=>f;
		SREC*=>f;
		Math.atan(f)=>f;
		f/(f+1.0)=>g;
	}
}
