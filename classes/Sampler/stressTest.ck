Sampler s;

s.output=>dac;
s.init(".");

0.2=>s.output.gain;

for(int i;i<s.paths.cap();i++){
	for(int j;j<i;j++){
		s.trigger(j);
		chout<=j<=" ";
	}
	chout<=IO.nl();
	500::ms=>now;
}
