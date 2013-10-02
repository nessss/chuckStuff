[0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0]@=>float pubup[];
scootArray(pubup);
for(int i;i<pubup.size();i++)<<<pubup[i]>>>;
scootArray(pubup);
for(int i;i<pubup.size();i++)<<<pubup[i]>>>;


fun float[] scootArray(float f[]){
	for(f.size()-1=>int i;i>0;i--){
		f[i-1]=>f[i];
	}
	0=>f[0];
	return f;
}
