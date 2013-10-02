FileIO fio;
fio.open("./data/samplePaths.txt",FileIO.READ);
string paths[0];
while(fio.more()){
	fio.readLine()=>string line;
	if(line!=""){
		me.dir()+"/data/"+line=>line;
		paths<<line;
	}
}

for(int i;i<paths.size();i++){
	chout<=paths[i]<=IO.newline();
}
