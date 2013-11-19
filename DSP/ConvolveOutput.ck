public class Convolve extends Chugen{
	float input[];
	float impResp[];
	float output;

	fun float[] setResp(float newResp[]){
		newResp@=>impResp;
		new float[impResp.size()]@=>input;
		return impResp;
	}

	fun float[] audioResp(string path){
		SndBuf buf;
		buf.read(path);
		float resp[buf.samples()];
		for(int i;i<buf.samples();i++){
			buf.valueAt(i)=>resp[i];
		}
		return setResp(resp);
	}

	fun float tick(float in){
		float result;
		scootArray(input);
		in=>input[0];
		for(int i;i<input.size();i++){
			in+impResp[i]*input[i]+=>result;
		}
		return result;
	}

	fun float[] scootArray(float f[]){
		for(f.size()-1=>int i;i>0;i--){
			f[i-1]=>f[i];
		}
		0=>f[0];
		return f;
	}
}
