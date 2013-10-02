public class convolve extends Chugen{

	[1.0,0.0]@=>float impResp[];		// Default impulse response is delta function
	float output[2];

	fun float audioResp(string path){
		SndBuf buf=>blackhole;
		buf.read(path);
		float samples[buf.samples()];
		for(int i;i<buf.samples();i++){
			buf.valueAt(i)=>samples[i];
		}
		setResp(samples);
	}

	fun float[] setResp(float nResp[]){ // Setter is necessary because array 
		nResp@=>impResp;				// capacities need to be set
		new float[impResp.size()]@=>output;
		return impResp;
	}

	fun float[] calcResp(float input){
		float resp[impResp.size()];
		for(int i;i<impResp.size();i++){
			input*impResp[i]=>resp[i];
		}
		return resp;
	}

	fun float tick(float input){
		calcResp(input)@=>float newResp[];	                 // Calculate response
		for(int i;i<output.size();i++){
			if(i!=(output.size()-1))output[i+1]=>output[i];  // Scoot the array down
			else 0=>output[i];
			newResp[i]+=>output[i];                          // Add our new response to the output array
		}
		return output[0];									 // Return the next sample
	}
}
