int array[8];
for(int i;i<array.size();i++){
	i=>array[i];
}

for(int i;i<array.size();i++){
	<<<array[i]>>>;
}

scooty(array,-3);

for(int i;i<array.size();i++){
	<<<array[i]>>>;
}

fun void scoot(int a[],int s){
	a[s%a.size()]=>int last;
	a[0]=>int next;
	for(int i;i<a.size();i++){
		a[(i+s)%a.size()]=>next;
		a[i]=>a[(i+s)%a.size()];
	}
	last=>a[0];
}

fun int[] scooty(int a[],int s){
	while(s<0)a.size()+=>s;
	int result[a.size()];
	for(int i;i<a.size();i++){
		a[i]=>result[(i+s)%a.size()];
		<<<i,(i+s)%a.size()>>>;
	}
	for(int i;i<a.size();i++)result[i]=>a[i];
	return result;
}
