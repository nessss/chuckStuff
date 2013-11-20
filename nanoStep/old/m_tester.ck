RhythmSequencer rseq;
Clock clk;
Sampler sampler;

sampler.init("snr");
clk.init();
rseq.init(sampler);
rseq.stepOn(0);
rseq.stepOn(5);
rseq.stepOn(6);
sampler.output => dac;

sampler.gain(2);
sampler.trigger(0);

while(samp=>now);