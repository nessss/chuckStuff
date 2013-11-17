public class BubbleSort{
	int a[0];
	int audio;
	dur delay;
	int notes[0];
	SinOsc s;
	float g;
		
	fun int[] init(int n){
		n=>a.size;
		n=>notes.size;
		for(int i;i<a.size();i++){
			i=>a[i];
			45+i=>notes[i];
		}
		0.5=>g;
		return a;
	}

	fun int audioMode(){return audio;}
	fun int audioMode(int a){
		if(a){
			1=>audio;
			s=>dac;
		}
		return audio;
	}
	
	fun dur audioDelay(){return delay;}
	fun dur audioDelay(dur d){
		d=>delay;
		return delay;
	}
	
	fun int note(int n){return notes[n];}
	fun int note(int n,int a){
		a=>notes[n];
		return notes[n];
	}
	
	fun void printArray(int a[]){
		string printy;
		for(int i;i<a.size();i++){
			a[i]+" "+=>printy;
		}
		chout<=printy<=IO.nl();
	}


	fun int[] shuffle(int a[]){
		g=>s.gain;
		for(int i;i<a.size();i++){
			swap(a,i,Math.random2(0,a.size()-1));
		}
		return a;
	}

	fun int[] swap(int a[],int n,int n2){
		int b;
		if(audio){
			Std.mtof(notes[a[n2]])=>s.freq;
			delay=>now;
			Std.mtof(notes[a[n]])=>s.freq;
			delay=>now;
		}
		a[n]=>b;
		a[n2]=>a[n];
		b=>a[n2];
		return a;
	}

	fun int[] sort(int a[]){return sort(a,0);}
	fun int[] sort(int a[],int verbosity){
		g=>s.gain;
		if(a.size()<=1)return a; // array of size 0 or 1 is already in order
		else{
			int b;
			while(!checkOrder(a,verbosity)){
				for(int i;i<a.size()-1;i++){
					if(a[i]>a[i+1]){
						Std.mtof(notes[i])=>s.freq;
						delay=>now;
						Std.mtof(notes[i+1])=>s.freq;
						delay=>now;
						if(verbosity)<<<"Swapping "+i+"("+a[i]+") and "+(i+1)+"("+a[i+1]+")","">>>;
						swap(a,i,i+1);
					}
				}
			}
		}
		return a;
	}

	fun int checkOrder(int a[]){return checkOrder(a,0);}
	fun int checkOrder(int a[],int verbosity){
		for(int i;i<a.cap()-1;i++){
			if(a[i]>a[i+1]){
				return 0;	// if any element is greater than the next,
				break;						// array is out of order
			}
		}if(verbosity)printArray(a);
		return 1;				
	}
}
