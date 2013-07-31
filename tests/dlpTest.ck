DLP dlp;
float l,r,f,d,tau,t;

1=>dlp.lp.Q;
0.0=>dlp.data;
dlp.go();

for(127=>int i;i>0;i--){
	Std.mtof(i)=>f;
	1.0/(2*pi*f)=>tau;
	(2.5*tau)*1000.0=>t;
	test(f,10.0)=>r;
	//test(f,-10.0)=>d;
	
	<<<i,f+" Hz: "+r+" ms; tau = "+tau,t,t-r,r-d,"">>>;
	r=>l;
}

for(200=>int i;i>0;i--){
	<<<slewTimeToFreq(i::ms)>>>=>float f;
	<<<test(f,10),"">>>;
}

<<<"done!">>>;
dlp.stop();

fun float slewTimeToFreq(dur slewTime){
	slewTime/second=>float t;
	return 2.5/(2*pi*t);
}

fun float test(float f,float ping){
	Math.sgn(ping)=>float sgn;
	dlp.freq(f);
	ping=>dlp.data;
	now=>time begin;
	if(sgn>0){
		while(dlp.val<0.9999*ping){
			samp=>now;
		}
	}else{
		while(dlp.val>0.9999*ping){
			samp=>now;
		}
	}
	now=>time end;
	dlp.freq(2000);
	0.0=>dlp.data;
	if(sgn>0){
		while(dlp.val>0.0001*ping){
			samp=>now;
		}
	}else{
		while(dlp.val<0.0001*ping){
			samp=>now;
		}
	}
	10::ms=>now;
	return (end-begin)/ms;
}
