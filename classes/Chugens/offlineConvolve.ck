Convolve con;
SndBuf inBuf;
WvOut wout;

me.arg(0)=>string inPath;
inPath.rfind(".")=>int dotPos;
inPath.substring(0,dotPos)=>string outPath;
inPath.substring(dotPos)=>string extension;
"Convolved"+extension+=>outPath;
inBuf.read(inPath);
wout.wavFilename(outPath);

chout<="Input path:  "<=inPath<=IO.nl();
chout<="Output path: "<=outPath<=IO.nl();

me.arg(1)=>string impPath;
con.audioResp(impPath);

chout<=con.impResp.cap()<=IO.nl();
chout<=inBuf.samples()<=IO.nl();

inBuf=>con=>wout=>blackhole;

(inBuf.samples()+con.impResp.cap())::samp=>now;

wout.closeFile();
