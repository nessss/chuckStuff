DLP dlp;
float times[100];

1.0=>dlp.data;
dlp.go();

for(1000=>int i;i>0;i--){
	<<<i+" Hz: "+test(i,100.0)+" samps">>>;
}

<<<"done!">>>;
dlp.stop();

fun float test(float f,float ping){
	dlp.freq(f);
	ping=>dlp.data;
	now=>time begin;
	while(dlp.val<0.99*ping){
		samp=>now;
	}
	now=>time end;
	dlp.freq(2000);
	0.0=>dlp.data;
	while(dlp.val>0.01*ping){
		samp=>now;
	}
	return (end-begin)/samp;
}
