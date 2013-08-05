Step s => WarpTable wp => blackhole;
//linear
wp.coefs( [1., 1. ] );

//UGen based index
1 => s.next;
//allow for the value to be updated
samp => now;

//both should be 1.000000
<<<wp.lookup()>>>;
<<<s.last()>>>;
