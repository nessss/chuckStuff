RadixSort bs;
int a[];
bs.init(32)@=>a;
bs.audioMode(0);
//bs.audioDelay(20::ms);
bs.shuffle(a);
bs.printArray(a);
bs.sort(a,0)@=>a;
bs.printArray(a);
