SndBufN s;

s.output.chan(0)=>dac.chan(0);
s.output.chan(1)=>dac.chan(1);

s.read("data/panCheck.wav");
<<<s.channels()>>>;
s.gain(0.2);
//s.pos(s.samples());
/*
<<<s.channels()>>>;
s.trigger();
2::second=>now;
s.mute();

0.5::second=>now;

s.startPhase(0.2);
s.trigger();
2::second=>now;

0.5::second=>now;
debug();
<<<"","">>>;
s.startPhase(0.2);

debug();
<<<"","">>>;
s.endPhase(0.35);
debug();
<<<"","">>>;
s.trigger();
s.lengthDuration()=>now;

0.5::second=>now;
s.reverse();
debug();
<<<"","">>>;
s.trigger();
s.lengthDuration()=>now;
*/
s.trigger();
s.lengthDuration()=>now;

fun void debug(){
	<<<"Phs:",s.startPhase(),s.endPhase(),s.lengthPhase()>>>;
	<<<"Dur:",s.startDuration()/ms,s.endDuration()/ms,s.lengthDuration()/ms>>>;
	<<<"Pos:",s.startPosition(),s.endPosition(),s.lengthSamples()>>>;
}
