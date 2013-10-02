FileIO fio;
20=>int compsToPlay;
string paths[0];
int fileCount;

if(me.args()){
    Std.atoi(me.arg(0))=>compsToPlay;
}

if(fio.open(me.sourceDir()+"/paths.txt",FileIO.READ)){
    if(fio.good()){
        while(fio.more()){
            paths<<fio.readLine();
            if(paths[paths.size()-1]=="")paths.popBack();
            else me.sourceDir()+"/compositions/"+paths[paths.size()-1]=>paths[paths.size()-1];
        }
    }else{
        <<<"Couldn't open sample path file...","">>>;
        me.exit();
    }
}else{
    <<<"Couldn't open sample path file...","">>>;
    me.exit();
}

if(compsToPlay>(paths.size()))paths.size()=>compsToPlay;

for(int i;i<paths.size();i++){
    string temp[2];
    Math.random2(0,paths.size()-1)=>int randIdx;
    paths[i]=>temp[0];
    paths[randIdx]=>temp[1];
    temp[0]=>paths[randIdx];
    temp[1]=>paths[i];
}

for(int i;i<compsToPlay;i++){
    Machine.add(paths[i])=>int shredID;
    Shred.fromId(shredID)@=>Shred compShred;
    while(second=>now){
        if(compShred.done())break;
    }
}

