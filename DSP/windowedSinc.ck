50=>int NUM_SAMPS;
windowedSinc()@=>float windowedSinc[NUM_SAMPS];

fun float[] windowedSinc(){
	sinc()@=>float sincSamples[];
	blackmanWindow()@=>float windowSamps[];
	float result[NUM_SAMPS];
	for(int i;i<NUM_SAMPS;i++)sincSamples[i]*windowSamps[i]=>result[i];
	return result;
}

fun float[] sinc(){
	float result[NUM_SAMPS];
	for(int i;i<NUM_SAMPS;i++)Math.sin(Math.TWOPI*(i-(NUM_SAMPS/2)))/(Math.TWOPI*(i-(NUM_SAMPS/2)))=>result[i];
	return result;
}

fun float[] blackmanWindow(){
	7938.0/18608.0=>float a0;
	9240.0/18608.0=>float a1;
	1430.0/18608.0=>float a2;
	float result[NUM_SAMPS];
	for(int i;i<NUM_SAMPS;i++){
		a0-a1(Math.cos((Math.TWOPI*i)/NUM_SAMPS))+a2(Math.cos((Math.TWOPI*2*i)/NUM_SAMPS))=>result[i];
	}
	return result;
}
