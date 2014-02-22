public class OverSampler extends Chugen{
	
	Math.PI=>float PI;
	Math.TWO_PI=>float TWOPI;
	9=>int oversampleFactor;
	(second/samp)=>float S_RATE;
	S_RATE/2.0=>float cutoffFreq;
	20.0=>float distAmt;
	//0.5984=>float outGain;
	1=>float outGain;

	float inputBuffer[0];
	float alpha[0]; // to be set in init
	float distortBuffer[0];


	// foldback variables
    0.6 => float foldThresh;
    2.0 => float foldIndex;
    
	fun void printCoef(){
		for(int i;i<alpha.cap();i++){
			chout<=alpha[i]<=IO.nl();
		}
	}
	
	fun void init(int nFactor,float nFreq,float nDistAmt,float nGain){
		nFactor=>oversampleFactor;
		if(!(oversampleFactor%2))1+=>oversampleFactor;
		nFreq=>cutoffFreq;
		nDistAmt=>distAmt;
		nGain=>outGain;
		
		calcCoef(cutoffFreq,oversampleFactor,S_RATE)@=>alpha;
		inputBuffer.size(oversampleFactor);
		distortBuffer.size(alpha.cap());
	}

	fun void init(int nFactor){
		nFactor=>oversampleFactor;
		calcCoef(cutoffFreq,nFactor,S_RATE)@=>alpha;
		inputBuffer.size(oversampleFactor);
		distortBuffer.size(alpha.cap());
	}

	fun void init(){
		calcCoef(cutoffFreq,oversampleFactor,S_RATE)@=>alpha;
		inputBuffer.size(oversampleFactor);
		distortBuffer.size(alpha.cap());
	}

	fun float[] calcCoef(float os_freq,int os_factor,float sRate){
		os_freq/(os_factor*sRate)=>float normFreq;
		chout<="Norm freq: "<=normFreq<=IO.nl();
		Math.pow(os_factor,2)$int=>int numCoef;
		float result[numCoef];
		((numCoef-1.0)/2.0)$int=>int m_2;  // middle coefficient
		for(int i;i<numCoef;i++){   // calculate coefficients based on sinc function
			if(i==m_2)2*normFreq=>result[i];
			else{
				Math.sin(normFreq*TWOPI*(i$float-m_2))/((i$float-m_2)*Math.PI)=>result[i];
			}
		}

		for(int i;i<numCoef;i++){
			Math.cos((i$float/(numCoef-1))*TWOPI)*0.49656=>float blackmanCoef_a;
			Math.cos((i$float/(numCoef-1))*2*TWOPI)*0.076849=>float blackmanCoef_b;
			0.42659-blackmanCoef_a+blackmanCoef_b=>float blackmanCoef;
			blackmanCoef*=>result[i];
			chout<="blackman coef "<=i<=": "<=blackmanCoef<=IO.nl();
		}
		return result;
	}

	fun float tick(float in){
		distAmt*=>in;
		for(inputBuffer.cap()-1=>int i;i>0;i--){
			inputBuffer[i-1]=>inputBuffer[i]; // scoot array towards end 
		}
		in=>inputBuffer[0];
		for(inputBuffer.cap()-1=>int i;i>oversampleFactor;i--){
			inputBuffer[i-oversampleFactor]=>inputBuffer[i];
		}
		for(int i;i<oversampleFactor;i++){
			distort(upsampleFilter(i,inputBuffer,alpha))=>distortBuffer[i];
		}

		return downsampleFilter(distortBuffer,alpha)*outGain;
		//return distortBuffer[0];
	}

	fun float upsampleFilter(int offset,float buffer[],float coef[]){
		float y;
		for(int i;i<oversampleFactor;i++){
			buffer[i]*coef[i*oversampleFactor+offset]+=>y;
		}
		return y;
	}

	fun float downsampleFilter(float buffer[],float coef[]){
		float y;
		for(int i;i<coef.cap();i++){
			buffer[i]*coef[i]+=>y;
		}
		return y;
	}
    
    fun float distort(float in){
        0=>float out;
        1.0/foldThresh=>float gain;
        in=>out;
        while(out>foldThresh)foldIndex*(out-foldThresh)-=>out;
        while(out<(-1.0*foldThresh))foldIndex*(out+foldThresh)-=>out;
        return out*gain;
    }
}
