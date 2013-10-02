//This class lets you reference control names 
//instead of memorizing CC#s

public class NanoKONTROL2{
    //Channel Strips (1 through 8)
    int fader[8];
    int knob[8];
    int button[8][3];

    for(0 => int i; i < 8; i++){ //Sets above arrays
        i => knob[i];
        8 + i => button[i][0];
        16 + i => button[i][1];
        24 + i => button[i][2];
        32 + i => fader[i];
    }
    //transport
    int trans[11];
    for(0 => int i; i<trans.cap(); i++){
        40 + i => trans[i];
    }
    trans[0] => int rew; //Rewind
    trans[1] => int ffw; //Fast Forward
    trans[2] => int stp; //Stop
    trans[3] => int ply; //Play
    trans[4] => int rec; //Record
    trans[5] => int cyc; //Cycle
    trans[6] => int set; //Set
    trans[7] => int mlf; //M Left
    trans[8] => int mrt; //M Right
    trans[9] => int tlf; //T Left
    trans[10] => int trt; //T Right

    fun int isFader(int cc){
    	0=>int result;
    	for(int i;i<fader.size();i++){
    		if(cc=fader[i])1=>result;
    	}
    	return result;
    }

    fun int faderNum(int cc){
    	if(isFader(cc)){
    		return cc-32;
    	}
    	return -1;
    }

    fun int isKnob(int cc){
    	0=>int result;
    	for(int i;i<knob.size();i++){
    		if(cc=knob[i])1=>result;
    	}
    	return result;
    }

    fun int knobNum(int cc){
    	if(isKnob(cc)){
    		return cc;
    	} 
    	return -1;
    }

    fun int isButton(int cc){
    	0=>int result;
    	for(int i;i<button.size();i++){
    		for(int j,j<button[0].size();i++){
    			if(cc=button[i][j])1=>result;
    		}
    	}
    	return result;
    }

    fun int[] buttonPos(int cc){
    	int result[2];
    	buttonCol(cc)=>result[0];
    	buttonRow(cc)=>result[1];
    	return result;
    }
    
    fun int buttonCol(int cc){
    	-1=>int result;
    	if(isButton(cc)){
    		for(int i;i<button.size();i++){
    			for(int j,j<button[0].size();i++){
    				if(cc=button[i][j])i=>result;
    			}
    		}
    	}
    	return result;
    }

    fun int buttonRow(int cc){
    	-1=>int result;
    	if(isButton(cc)){
    		for(int i;i<button.size();i++){
    			for(int j,j<button[0].size();i++){
    				if(cc=button[i][j])j=>result;
    			}
    		}
    	}
    	return result;
    }

    fun int isTransport(int cc){
    	0=>int result;
    	for(int i;i<trans.size();i++){
    		if(cc=trans[i])1=>result;
    	}
    	return result;
    }	

	fun int isControl(int cc){
		if(isFader(cc)|isKnob(cc)|isButton(cc)|isFader(cc))return 1;
		return 0;
	}
}      
