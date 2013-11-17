public class OverSampler extends Chugen{
	
	Math.PI=>float PI;
	Math.TWO_PI=>float TWOPI;
	10=>int oversampleFactor;
	(second/samp)=>float S_RATE;
	S_RATE/2.0=>float freq;
	20.0=>float distAmt;
	0.5984=>float outGain;

	float alpha[100];

	fun void printCoef(){
		for(int i;i<alpha.cap();i++){
			chout<=alpha[i]<=IO.nl();
		}
	}
	
	fun void init(int nFactor,float nFreq,float nDistAmt,float nGain){
		nFactor=>oversampleFactor;
		if(!(oversampleFactor%2))1+=>oversampleFactor;
		nFreq=>freq;
		nDistAmt=>distAmt;
		nGain=>outGain;
		
		calcCoef(freq,oversampleFactor,S_RATE)@=>alpha;
	}

	fun void init(){
		calcCoef(freq,oversampleFactor,S_RATE)@=>alpha;
	}

	fun void init(int oFactor){
		calcCoef(freq,oFactor,S_RATE)@=>alpha;
	}

	fun float[] calcCoef(float os_freq,int os_factor,float sRate){
		os_freq/(os_factor*sRate)=>float normFreq;
		Math.pow(os_factor,2)$int=>int numCoef;
		float result[numCoef];
		((numCoef-1.0)/2.0)$int=>int m_2;  // middle coefficient
		for(int i;i<numCoef;i++){   // calculate coefficients based on sinc function
			Math.cos((i/(numCoef-1))*TWOPI)*0.49656=>float blackmanCoef_a;
			Math.cos((i/(numCoef-1))*2*TWOPI)*0.076849=>float blackmanCoef_b;
			0.42659-blackmanCoef_a+blackmanCoef_b=>float blackmanCoef;
			if(i==m_2)2*normFreq*blackmanCoef=>result[i];
			else{
				Math.sin(normFreq*TWOPI*(i-m_2))/((i-m_2)*Math.PI)*blackmanCoef=>result[i];
			}
		}
		return result;
	}

	fun float tick(float in){
		float result;

		return result;
	}

	fun float distort(float x){
		return x/(Math.fabs(x)+1);
	}	
}
