public class ArrayTools{
	fun static int[] subArray(int a[],int length){
		int result[length];
		for(int i;i<length;i++){
			a[i]=>result[i];
		}
		return result;
	}

	fun static int[] concat(int a[],int b[],int c[]){return concat(concat(a,b),c);}
	fun static int[] concat(int a[],int b[]){
		<<<"Concatenating...","">>>;
		if(a.size()==0)return b;
		if(b.size()==0)return a;
		int result[a.cap()+b.cap()];
		for(int i;i<result.cap();i++){
			if(i<a.cap()){
				a[i]=>result[i];
			}else{
				b[i-a.cap()]=>result[i];
			}
		}
		<<<"Done.","">>>;
		return result;
	}
	
	fun static int[] rotate(int a[],int n){
		int result[a.size()];
		for(int i;i<a.size();i++){
			a[Math.abs(i+n)%a.size()]=>result[i];
		}
		return result;
	}
}
