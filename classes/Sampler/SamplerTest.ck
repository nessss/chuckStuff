Sampler s;

s.output=>dac;

s.init("kck");
<<<s.paths.size()>>>;

int i;
while(second=>now){
	<<<s.paths[i]>>>;
	<<<s.getKit(i),s.getName(i)>>>;
	s.trigger(i);
	i++;
	s.paths.size()%=>i;
}
