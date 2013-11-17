public class Quicksort extends BubbleSort{
	fun int[] sort(int theArray[],int verbosity){
		printArray(theArray);
		<<<"Size: "+theArray.cap(),"">>>;
		if(theArray.cap()<=1)return theArray;
		Math.random2(0,theArray.cap()-1)=>int pivot;
		<<<"Pivot: "+theArray[pivot],"">>>;
		int less[0];
		int more[0];
		for(int i;i<theArray.cap();i++){
			if(i!=pivot){
				if(theArray[i]<theArray[pivot]){
					less<<theArray[i];//=>less[less.cap()-1];
				}else if(theArray[i]>=theArray[pivot]){
					more<<theArray[i];//=>more[more.cap()-1];
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
