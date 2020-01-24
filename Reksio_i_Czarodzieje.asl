state("Czarodzieje"){}

startup{
	refreshRate = 30;
	
	//settings.Add("inSplitter",false);
	//settings.SetToolTip("inSplitter","If unchecked, splitter is synchronized with splits in LiveSplit, otherwise autosplitter uses own split counter, allowing for additional manual splits.");
	settings.Add("checkStart",true);
}

init{
	//leave
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
	
	Func<int,bool> getWiz = position=>{
		byte[] czarodziej=new byte[1];
		vars.invFile.Seek(position*8+8,SeekOrigin.Begin);
		vars.invFile.Read(czarodziej,0,1);
		if(czarodziej[0]>0){
			return true;
		}else{
			return false;
		}
	};
	
	Func<FileStream, int> getMini= file =>{
		byte[] byt=new byte[1];
		file.Seek(8,SeekOrigin.Begin);
		file.Read(byt,0,1);
		return byt[0];
	};
	
	Func<int> getSplit=()=>{
		return timer.CurrentSplitIndex;
	};
	
	var page = modules.First();
	var gameDir = Path.GetDirectoryName(page.FileName);
	vars.saveDir=gameDir+"\\Common\\";
	
	vars.gameFile=new FileStream(vars.saveDir+"GAME0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	vars.invFile=new FileStream(vars.saveDir+"INVEST0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	vars.miotFile=new FileStream(vars.saveDir+"MIOTLY0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	vars.shootFile=new FileStream(vars.saveDir+"SHOOTER0.ARR", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	
	vars.prog=0;
	vars.starter=settings["checkStart"];
	
	
	//instruction
	
	//get current split
	vars.getSplit=getSplit;
	
	//check Reksio's location
	vars.getLoc=getLoc;
	
	//check if player already got wizard's testimony
	vars.getWiz=getWiz;
	
	//check for one-byte value in arr file
	vars.getMini=getMini;
	
	vars.idBurektor=0;
	vars.idGulguldryk=1;
	vars.idSnejk=2;
	vars.idWaldi=3;
	vars.idSpielmauster=4;
	vars.idChrumburak=5;
	vars.idBarandalf=6;
	
	

}

start{
	if(vars.getLoc("INTRO"))
		vars.starter=false;
	if(vars.getLoc("HILLS")&&vars.starter==false){
		return true;
	}
}

split{
	
	//modify
	int curr=vars.getSplit();
	switch (curr)
	{
		case 0:
			if(vars.getLoc("TELEP_PODWORKO"))
				return true;
			break;
			
		case 1:
			if(vars.getLoc("GABINETDYR"))
				return true;
			break;

		case 2:
			if(vars.getLoc("MIOTSHOP"))
				return true;
			break;

		case 3:
			if(vars.getLoc("SHOOTER"))
				return true;
			break;

		case 4:
			if(vars.getLoc("MIOTLY"))
				return true;
			break;

		case 5:
			if(vars.getWiz(vars.Spielmauster))
				return true;
			break;

		case 6:
			if(vars.getLoc("MIOTLY")&&(vars.getMini(vars.miotFile)==2||vars.getMini(vars.miotFile)==4))
				return true;
			break;

		case 7:
			if(vars.getWiz(vars.Chrumburak)||vars.getWiz(vars.Barandalf))
				return true;
			break;

		case 8:
			if(vars.getLoc("MIOTLY")&&(vars.getMini(vars.miotFile)==2||vars.getMini(vars.miotFile)==4))
				return true;
			break;

		case 9:
			if(vars.getWiz(vars.Chrumburak)&&vars.getWiz(vars.Barandalf))
				return true;
			break;

		case 10:
			if(vars.getLoc("SHOOTER")&&vars.getMini(vars.shootFile)==2)
				return true;
			break;

		case 11:
			if(vars.getLoc("SALA"))
				return true;
			break;

		case 12:
			if(vars.getLoc("OUTRO_1"))
				return true;
			break;

	}
}