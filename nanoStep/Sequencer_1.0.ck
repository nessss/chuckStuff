//Sequencer base class
public class Sequencer{
    int pLen, nSteps, cStep;
    int nPats, pPlay, pEdit;
    int ons[][];
    Shred clockIn;
    
    //Initializer
    fun void _init(){
        //Defaults
        0   => cStep => pPlay => pEdit;
        8   => pLen => nPats;
        128 => nSteps;
        new int[nPats][nSteps] @=> ons;
        clearAllOns();
        spork ~ clockInput();
    }
    
    
    //Functions 
    fun int numPats(){ return nPats; }
    
    fun void toggleStepOn(){
        if(stepIsOn()) stepOff();
        else stepOn();
    }
    
    fun void toggleStepOn(int s){
        if(stepIsOn(s)) stepOff(s);
        else stepOn(s);
    }
    
    fun void stepOn(){
        1 => ons[pEdit][cStep];
    }
    
    fun void stepOn(int s){
        1 => ons[pEdit][s];
    }
    
    fun void stepOn(int p, int s){
        if(s>=0 & s<nPats){
            1 => ons[p][s];
        }
    } 
    
    fun void stepOff(){
        0 => ons[pEdit][cStep];
    }
    
    fun void stepOff(int s){
        0 => ons[pEdit][s];
    }
    
    fun void stepOff(int p, int s){
        if(s>=0 & s<nPats){
            0 => ons[p][s];
        }
    } 
    
    fun void clearAllPats(int a[][]){
        for(int i; i<nPats; i++){
            clearPat(a, i);
        }
    }
    
    fun int stepIsOn(){ return stepIsOn(cStep); }
    
    fun int stepIsOn(int s){
        if(ons[pEdit][s]) return 1;
        else return 0;
    }
    
    fun int currentStep(){ return cStep; }
    
    fun void clearAllOns(){
        clearAllPats(ons);
    }
    
    fun void clearOns(){
        clearPat(ons);
    }
    
    fun void clearOns(int p){
        clearPat(ons, p);
    }
    
    //Pattern/Array Utilites
    fun void scootPat(int a[][], int s){
        while(s<0) pLen + s => s;
        int result[a.size()][a[0].size()];
        for(int i; i<pLen-1; i++){
            a[pEdit][i] => result[pEdit][(s+i)%pLen];
        }
        for(int i; i<pLen-1; i++){
            result[pEdit][i] => a[pEdit][i];
        }
    }
    
    fun void scootPat(float a[][], int s){
        while(s<0) pLen + s => s;
        float result[a[0].size()];
        for(int i; i<pLen-1; i++){
            a[pEdit][i] => result[(s+i)%pLen];
        }
        for(int i; i<pLen-1; i++){
            result[i] => a[pEdit][i];
        }
    }
    
    fun void randomizePat(int a[][]){
        for(int i; i<a.cap(); i++){
            Math.random2(0,1) => a[pEdit][i];
        }
    }
    
    fun void randomizePat(float a[][]){
        for(int i; i<a.cap(); i++){
            Math.random2f(0,1) => a[pEdit][i];
        }
    }
    
    fun void randomizePat(int a[][], int lo, int hi){
        for(int i; i<a.cap(); i++){
            Math.random2(lo, hi) => a[pEdit][i];
        }
    }    
    
    fun void randomizePat(float a[][], int lo, int hi){
        for(int i; i<a.cap(); i++){
            Math.random2f(lo, hi) => a[pEdit][i];
        }
    }
    
    fun void clearPat(int a[][]){
        for(int i; i<a.cap(); i++){
            0 => a[pEdit][i];
        }
    }    
    
    fun void clearPat(int a[][], int p){
        for(int i; i<a.cap(); i++){
            0 => a[p][i];
        }
    }
    
    fun void clearPat(float a[][]){
        for(int i; i<a.cap(); i++){
            0.0 => a[pEdit][i];
        }
    }    
    
    fun void setAllSteps(float a[][], int v){ 
        for(int i; i<a.cap(); i++){
            v => a[pEdit][i];
        }
    }
    
    fun void setAllSteps(int a[][], int v){
        for(int i; i<a.cap(); i++){
            if(v) v => a[pEdit][i];
        }
    }
    //Pattern Select Functionality
    fun int patPlaying(){ return pPlay; }
    fun int patPlaying(int pp){
        if(pp>=0 & pp<nPats) pp => pPlay;
        return pPlay;
    }
    
    fun int patEditing(){ return pEdit; }
    fun int patEditing(int pe){
        if(pe>=0 & pe<nPats) pe => pEdit;
        return pEdit;
    }
    
    fun int patLength(){ return pLen; }
    fun int patLength(int pl){
        if(pl>0 & pl<nSteps) pl => pLen;
        return pLen;
    }
    
    fun void kill(){ clockIn.exit(); }
    
    //Loops
    fun void clockInput(){
        OscRecv orec;
        98765 => orec.port;
        orec.listen();
        orec.event("/c, f") @=> OscEvent e;
        while(e => now){
            while(e.nextMsg() !=0){
                Math.fmod(e.getFloat(), pLen)$int => cStep;
                doStep();
            }
        }
    }
    
    fun void doStep(){ } //over-ride in child class 
}