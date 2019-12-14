state("Czarodzieje"){}

startup{
	refreshRate = 15;
	
	settings.Add("inSplitter",false);
	settings.SetToolTip("inSplitter","If unchecked, splitter is synchronized with splits in LiveSplit, otherwise autosplitter uses own split counter, allowing for additional manual splits.");
	settings.Add("checkStart",true);
}

init{
	
	//checks Reksio's location
	Func<string,bool> getLoc = name=>{
		byte[] buffer=new byte[name.Length];
		vars.gameFile.Seek(12,SeekOrigin.Begin);
		vars.gameFile.Read(buffer,0,buffer.Length);
		if(Encoding.UTF8.GetString(buffer, 0, buffer.Length)==name){
			return true;
		}else{
			return false;
		}
	};
	vars.getLoc=getLoc;
	
	//checks which wizard's testimony player aleady have
	Func<int,bool> getCzar = position=>{
		byte[] czarodziej=new byte[1];
		vars.invFile.Seek(position*8+8,SeekOrigin.Begin);
		vars.invFile.Read(czarodziej,0,1);
		if(czarodziej[0]>0){
			return true;
		}else{
			return false;
		}
	};
	vars.getCzar=getCzar;
	
	//checks for one-byte value in arr file
	Func<FileStream, int> getMini= file =>{
		byte[] byt=new byte[1];
		file.Seek(8,SeekOrigin.Begin);
		file.Read(byt,0,1);
		return byt[0];
	};
	vars.getMini=getMini;


	Func<int,bool> getSplit = pos=>{
		if((settings["inSplitter"]==true&&vars.prog==pos)||(settings["inSplitter"]==false&&timer.CurrentSplitIndex==pos)){
			return true;
		}else{
			return false;
		}
	};
	vars.getSplit=getSplit;
	
	
	
	
	
	var page = modules.First();
	var gameDir = Path.GetDirectoryName(page.FileName);
	vars.saveDir=gameDir+"\\Common\\";
	//vars.saveDir="E:\\AidemMedia\\Reksio i Czarodzieje\\Common\\";
	
	
	
	vars.gameFile=new FileStream(vars.saveDir+"GAME0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	vars.invFile=new FileStream(vars.saveDir+"INVEST0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	vars.miotFile=new FileStream(vars.saveDir+"MIOTLY0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	vars.shootFile=new FileStream(vars.saveDir+"SHOOTER0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	
	vars.prog=0;
	vars.starter=settings["starter"];
	
}

start{
	if(vars.getLoc("INTRO"))
		vars.starter=false;
	if(vars.getLoc("HILLS")&&vars.starter==false){
		return true;
	}
}

split{
	print(timer.CurrentSplitIndex.ToString());
	if(vars.getSplit(0)){
		if(vars.getLoc("TELEP_PODWORKO")){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(1)){
		if(vars.getLoc("GABINETDYR")){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(2)){
		if(vars.getLoc("MIOTSHOP")){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(3)){
		if(vars.getLoc("SHOOTER")){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(4)){
		if(vars.getLoc("MIOTLY")){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(5)){
		if(vars.getCzar(4)){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(6)){
		if(vars.getLoc("MIOTLY")&&(vars.getMini(vars.miotFile)==2||vars.getMini(vars.miotFile)==4)){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(7)){
		if(vars.getCzar(5)||vars.getCzar(6)){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(8)){
		if(vars.getLoc("MIOTLY")&&(vars.getMini(vars.miotFile)==2||vars.getMini(vars.miotFile)==4)){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(9)){
		if(vars.getCzar(5)&&vars.getCzar(6)){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(10)){
		if(vars.getLoc("SHOOTER")&&vars.getMini(vars.shootFile)==2){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(11)){
		if(vars.getLoc("SALA")){
			vars.prog++;
			return true;
		}
	}else if(vars.getSplit(12)){
		if(vars.getLoc("OUTRO_1")){
			vars.prog++;
			return true;
		}
	}
	
}