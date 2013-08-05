SinOsc s;
Envelope e;
WarpTable w;
float f;

init();

/*test(0.10,1000::ms);
test(0.25,1000::ms);
test(0.50,1000::ms);
test(0.75,1000::ms);
*/
1.375=>float c;

test(c,50::ms);
test(c,100::ms);
test(c,200::ms);
test(c,500::ms);
test(c,1000::ms);


1.39=>c;

test(c,50::ms);
test(c,100::ms);
test(c,200::ms);
test(c,500::ms);
test(c,1000::ms);


1.4=>c;

test(c,50::ms);
test(c,100::ms);
test(c,200::ms);
test(c,500::ms);
test(c,1000::ms);


fun void init(){
	w.coefs([1.0,1.0]);
	s=>dac;
	e=>blackhole;
	e.duration(1000::ms);
	0.0=>e.value;
}

fun void slide(float begin,float end,Osc s){
	e.keyOn();
	end-begin=>float diff;
	while(samp=>now){
		(w.lookup(e.value())*diff)+begin=>s.freq;
		if(e.value()==1.0)break;
	}
	e.keyOff();
	0.0=>e.value;
}

fun void test(float c,dur t){
	<<<"Asymmetric warp coefficient: "+4.0,"">>>;
	<<<"Symmetric warp coefficient: "+c,"">>>;
	w.coefs([4.0,c]);
	e.duration(t);
	Std.mtof(45)=>s.freq;
	t=>now;
	slide(s.freq(),s.freq()*2,s);
	t=>now;
}
