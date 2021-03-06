public class CocktailSort extends BubbleSort{
	fun int[] sort(int a[]){return sort(a,0);}
	fun int[] sort(int a[],int verbosity){
		if(a.cap()<=1)return a; // array of size 0 or 1 is already in order
		else{
			int b;
			while(!checkOrder(a,verbosity)){
				for(int i;i<a.cap()-1;i++){
					if(a[i]>a[i+1]){
						Std.mtof(notes[i])=>s.freq;
						delay=>now;
						Std.mtof(notes[i+1])=>s.freq;
						delay=>now;
						if(verbosity)<<<"Swapping "+i+"("+a[i]+") and "+(i+1)+"("+a[i+1]+")","">>>;
						swap(a,i,i+1);
					}
				}
				for(a.cap()-1=>int i;i>0;i--){
					if(a[i]<a[i-1]){
						Std.mtof(notes[i])=>s.freq;
						delay=>now;
						Std.mtof(notes[i-1])=>s.freq;
						delay=>now;
						if(verbosity)<<<"Swapping "+i+"("+a[i]+") and "+(i+1)+"("+a[i+1]+")","">>>;
						swap(a,i,i-1);
					}
				}
			}
		}return a;
	}
}
