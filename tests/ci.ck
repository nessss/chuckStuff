ConsoleInput ci;

string s;

ci.prompt("Nyan!\n")=>now;
while(ci.more()){
	ci.getLine()=>s;
	<<<s>>>;
}

