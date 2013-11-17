public class ArrayTools{
	fun static int[] subArray(int a[],int length){
		int result[0];
		for(int i;i<length;i++){
			result<<a[i];
		}
		return result;
	}

	fun static int[] concat(int a[],int b[],int c[]){return concat(concat(a,b),c);}
	fun static int[] concat(int a[],int b[]){
		if(a.cap()==0)return b;
		if(b.cap()==0)return a;
		int result[0];
		for(int i;i<a.cap();i++)result<<a[i];
		for(int i;i<b.cap();i++)result<<b[i];
		return result;
	}
	
	fun static int[] rotate(int a[],int n){
		int result[];
		for(int i;i<a.cap();i++){
			result<<a[Math.abs(i+n)%a.cap()];
		}
		return result;
	}
}
