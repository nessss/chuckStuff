public class Quicksort extends BubbleSort{
	fun int[] sort(int theArray[],int verbosity){
		printArray(theArray);
		<<<"Size: "+theArray.size(),"">>>;
		if(theArray.size()<=1)return theArray;
		Math.random2(0,theArray.size()-1)=>int pivot;
		<<<"Pivot: "+theArray[pivot],"">>>;
		int less[0];
		int more[0];
		for(int i;i<theArray.size();i++){
			if(i!=pivot){
				if(theArray[i]<theArray[pivot]){
					less.size()+1=>less.size;
					theArray[i]=>less[less.size()-1];
				}else if(theArray[i]>=theArray[pivot]){
					more.size()+1=>more.size;
					theArray[i]=>more[more.size()-1];
				}
			}
		}
		int Pivot[1];
		theArray[pivot]=>Pivot[0];
		printArray(less);
		printArray(more);
		printArray(theArray);
		ArrayTools.concat(sort(less),Pivot,sort(more))@=>int result[];
		printArray(result);
		return result;
	}
}