Sampler s;

s.output=>dac;

s.init("808/Kicks");

s.trigger(0);

1::second => now;

s.trigger(1);

while(samp=>now);
