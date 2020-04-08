state("ReksioPiraci"){
	string20 stage : "PIKLIB8.dll", 0x36A708,0x30,0x0;
}

startup{
	refreshRate = 60;
}

init{
	
	Func<string,bool> getLoc = name=>{
		try{
			if(string.Compare(name,0,current.stage,0,name.Length)==0){
				return true;
			}else{
				return false;
			}
		}catch(Exception e){
			print(current.stage);
			print(current.stage2);
			return false;
		}
	};
	vars.getLoc=getLoc;
	
	Func<int> getSplit=()=>{
		return timer.CurrentSplitIndex;
	};
	
	//get current split
	vars.getSplit=getSplit;
}

start{
	//modify
	if(vars.getLoc("NAWRAKU")){
		return true;
	}
}

split{
	int curr=vars.getSplit();
	switch (curr)
	{
		case 0:
			if(vars.getLoc("4PLAZA"))
				return true;
			break;
			
		case 1:
			if(vars.getLoc("RZEKA1"))
				return true;
			break;

		case 2:
			if(vars.getLoc("WIOSKA10"))
				return true;
			break;

		case 3:
			if(vars.getLoc("15POSAG"))
				return true;
			break;

		case 4:
			if(vars.getLoc("15BWTWAROGU"))
				return true;
			break;
		case 5:
			if(vars.getLoc("21MOST"))
				return true;
			break;
		case 6:
			if(vars.getLoc("ZAWAL"))
				return true;
			break;
		case 7:
			if(vars.getLoc("25PAPUGI"))
				return true;
			break;
		case 8:
			if(vars.getLoc("27STATEK"))
				return true;
			break;
		case 9:
			if(vars.getLoc("27BSTATEK"))
				return true;
			break;
	}
}