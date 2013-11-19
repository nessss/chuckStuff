float input[];
float re[];
float im[];

float bF[][][];


fun void setBF(){
	bF.size(input.cap()/2);
	bF[0].size(input.cap());
	bF[1].size(2);


	for(int i;i<bF.cap()){
		for(int j;j<bF.cap();j++){
			input[i]*Math.cos(TWO_PI*j*(i/input.cap()))=>bF[i][j][0];
			input[i]*Math.sin(TWO_PI*j*(i/input.cap()))=>bF[i][j][1];
		}
	}
}

fun void dft(){
	float correlation[input.cap()]
	for(int i;i<input.cap();i++){
		
	}
}




fun float avg(float a[]){
	float tot;
	for(int i;i<a.cap();i++){
		a[i]+=>tot;
	}
	return tot/(a.cap()$float);
}


fun float[] p2rec(float a, float p){
	float result[2];
	Math.cos(p)*a=>result[0];
	Math.sin(p)*a=>result[1];
	return result;
}

fun float[] p2rec(float p[]){
	float result[2];
	if(p.size()<2)return result;
	return p2rec(p[0],p[1]);
}

fun float[] rec2p(float x, float y){
	float result[2];
	Math.pow((Math.pow(x,2)+Math.pow(y,2)),0.5)=>result[0];
	Math.atan(y/x)=>result[1];
	return result;
}

fun float[] rec2p(float rec[]){
	float result[2];
	if(rec.size()<2)return result;
	return rec2p(rec[0],rec[1]);
}
