public class DataEvent extends Event{
    0=>int i;
    0.0=>float f;
    ""=>string s;
    int I[0];
    float F[0];
    string S[0];
    
    fun void arrayInit(string key,int cap){
    	if(key=="int"){
    		int n[cap]@=>I;
    	}else if(key=="float"){
    		float n[cap]@=>F;
    	}else if(key=="string"){
    		string n[cap]@=>S;
    	}
    }
}