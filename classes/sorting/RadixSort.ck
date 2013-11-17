public class RadixSort extends BubbleSort{
	2=>int base;
	0=>int maxDepth;

	fun int[] _sort(int a[],int verbosity,int depth){
		if(a.cap()<2)return a;
		if(checkOrder(a))return a;
		if(depth>maxDepth)return a;
		int buckets[base][0];
		for(int i;i<a.cap();i++){
			buckets[(a[i]/(Math.pow(base,depth)$int))%base]<<a[i];
		}
		int result[0];
		for(int i;i<buckets.cap();i++){
			chout<="Array "<=i<=": ";
			printArray(buckets[i]);
			ArrayTools.concat(result,buckets[i])@=>result;
		}
		chout<="In order? "<=checkOrder(result)<=IO.nl();
		if(!checkOrder(result)){
			printArray(result);
			_sort(result,0,depth+1)@=>result;
		}
		return result;
	}
	
	fun int[] sort(int a[],int verbosity){
		int max;
		for(int i;i<a.cap();i++)
			if(a[i]>max)a[i]=>max;
		while(max/base>0)base/=>max,maxDepth++;
		chout<="Maximum Depth: "<=maxDepth<=IO.nl();
		printArray(a);
		if(a.cap()<2)return a;
		int buckets[base][0];
		for(int i;i<a.cap();i++)
			buckets[a[i]%base]<<a[i];
		int result[0];
		for(int i;i<buckets.cap();i++){
			chout<="Array "<=i<=": ";
			printArray(buckets[i]);
			ArrayTools.concat(result,buckets[i])@=>result;
		}
		chout<="In order? "<=checkOrder(result)<=IO.nl();
		if(!checkOrder(result)){
			printArray(result);
			_sort(result,0,0)@=>result;
		}
		printArray(result);
		return result;
	}
}
