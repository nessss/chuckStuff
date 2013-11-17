Sampler s;

s.output=>dac;

s.init(".");
<<<s.paths.size()>>>;

int i;
while(second=>now){
	<<<s.paths[i]>>>;
	<<<s.getKit(i),s.getName(i)>>>;
	s.trigger(0);
	i++;
	s.paths.size()%=>i;
}
