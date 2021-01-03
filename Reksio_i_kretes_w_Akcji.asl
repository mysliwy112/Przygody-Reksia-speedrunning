state("Rex5"){}

startup{
	refreshRate = 15;
	settings.Add("startIntro",false,"Start At Intro");
	settings.SetToolTip("startIntro","Starts splitter when game is opened.");

	settings.Add("deleteSave",false,"Delete Save (experimental)");
	settings.SetToolTip("deleteSave","Deletes save at splitter start.");

	settings.Add("cleanSave",false,"Clean Save");
	settings.SetToolTip("cleanSave","Old method of reading save file.");

	settings.Add("writeLast",true,"Better precision (Warning, writes to disc)");

	settings.Add("sRiSP",true,"Split on each cutscene (RiSP)");
	settings.Add("scRiU",true,"Split on each cutscene (RiU)");
	settings.Add("sRiU",true,"Split on each level (RiU)","scRiU");
	settings.Add("scRiC",true,"Split on each cutscene (RiC)");
	settings.Add("sRiC",true,"Split on each level (RiC)","scRiC");
	settings.Add("sRiWC",true,"Split on each cutscene (RiWC)");
	settings.Add("scRiKN",true,"Split on each cutscene (RiKN)");
	settings.Add("sRiKN",true,"Split on each level (RiKN)","scRiKN");
}

init{

	Func<string> getLoc =()=>{
		vars.save.Seek(49,SeekOrigin.Begin);
		StreamReader sr = new StreamReader(vars.save);
		return sr.ReadLine();
	};

	Func<int> getSplit=()=>{
		return timer.CurrentSplitIndex;
	};

	Func<string,bool> changeGame=loc=>{
		if(loc==vars.lastLoc)
			return false;
		if(loc=="PIRACI0"){
			vars.max=vars.RiSPmax;
			vars.line=vars.RiSPline;
			vars.line2=vars.RiSPline2;
			vars.step=vars.max;
			vars.add=0;
			if(settings["sRiSP"])
				vars.step=1;
			vars.part=-1+vars.step;
			return true;
		}else
		if(loc=="RTYPE1"){
			vars.max=vars.RiUmax;
			vars.line=vars.RiUline;
			vars.line2=vars.RiUline2;
			vars.step=vars.max;
			vars.add=1;
			if(settings["sRiU"])
				vars.step=1;
			else if(settings["scRiU"])
				vars.step=4;
			vars.part=-1+vars.step;
			return true;
		}else
		if(loc=="MIOTLY1"){
			vars.max=vars.RiCmax;
			vars.line=vars.RiCline;
			vars.line2=vars.RiCline2;
			vars.step=vars.max;
			vars.add=1;
			if(settings["sRiC"])
				vars.step=1;
			else if(settings["scRiC"])
				vars.step=4;
			vars.part=-1+vars.step;
			return true;
		}else
		if(loc=="LABIRYNTY1"){
			vars.max=vars.RiWCmax;
			vars.line=vars.RiWCline;
			vars.line2=vars.RiWCline2;
			vars.step=vars.max;
			vars.add=1;
			if(settings["sRiWC"])
				vars.step=1;
			vars.part=-1+vars.step;
			return true;
		}else
		if(loc=="BDASH0"){
			vars.max=vars.RiKNmax;
			vars.line=vars.RiKNline;
			vars.line2=vars.RiKNline2;
			vars.step=vars.max;
			vars.add=0;
			if(settings["sRiKN"])
				vars.step=1;
			else if(settings["scRiKN"])
				vars.step=3;
			vars.part=-1+vars.step;
			return true;
		}
		return false;
	};
	
	var page = modules.First();
	var gameDir = Path.GetDirectoryName(page.FileName);
	vars.saveDir=gameDir+"\\common\\save\\";
	vars.save=new FileStream(vars.saveDir+"slot0.dta", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
	
	vars.prog=0;
	
	//instruction
	
	//get current split
	vars.getSplit=getSplit;
	vars.getLoc=getLoc;
	vars.changeGame=changeGame;

	vars.RiCline=146;
	vars.RiKNline=259;
	vars.RiSPline=417;
	vars.RiUline=534;
	vars.RiWCline=727;

	vars.RiCline2=130;
	vars.RiKNline2=244;
	vars.RiSPline2=402;
	vars.RiUline2=510;
	vars.RiWCline2=701;

	vars.RiSPmax=6;
	vars.RiUmax=12;
	vars.RiCmax=12;
	vars.RiWCmax=7;
	vars.RiKNmax=15;

	vars.RiSPstep=1;
	vars.RiUstep=1;
	vars.RiCstep=1;
	vars.RiWCstep=1;
	vars.RiKNstep=1;


	vars.part=-1;
	vars.max=-1;
	vars.line=-1;
	vars.line2=-1;
	vars.step=1;
	vars.first=true;
	vars.finalevel=false;
	vars.lastLoc=vars.getLoc();
}

start{
	var done=false;
	if(vars.first){
		if(settings["deleteSave"]){
			File.Copy(vars.saveDir+"slot_def.dta",vars.saveDir+"slot0.dta",true);
		}
		vars.part=-1;
		vars.max=-1;
		vars.line=-1;
		vars.line2=-1;
		vars.step=1;
		vars.first=false;
		vars.finalevel=false;
		vars.add=0;
		vars.lastLoc=vars.getLoc();
	}

	var loc=vars.getLoc();
	if(settings["startIntro"]){
		if(loc=="00_INTRO_TYTUL")
			done=true;
	}else{
		done=vars.changeGame(loc);
	}
	if(done){
		vars.first=true;
	}
	vars.lastLoc=loc;

	return done;
}

split{
	var loc=vars.getLoc();
	if(vars.part==-1){
		return vars.changeGame(loc);
	}else{
		if(settings["cleanSave"]||vars.finalevel){
			vars.save.Seek(vars.line+loc.Length,SeekOrigin.Begin);
			StreamReader sr = new StreamReader(vars.save);
			var line=sr.ReadLine();
			if(line[line.Length - vars.max+vars.part]=='U'){
				vars.part+=vars.step;
				if(vars.part>=vars.max){
					vars.part=-1;
					vars.finalevel=false;
				}
				return true;
			}
		}else{
			if(loc=="MIOTLY13"||loc=="BDASH15"||loc=="LABIRYNTY8"||loc=="PIRACI6"||loc=="RTYPE13"){
				vars.part=-1;
				vars.finalevel=false;
				return true;
			}else{
				vars.save.Seek(vars.line2+loc.Length,SeekOrigin.Begin);
				StreamReader sr = new StreamReader(vars.save);
				var line=sr.ReadLine();
				var level=int.Parse(line.Split('|')[1]);
				// print("Level: "+level);
				if(level==vars.part+vars.add+1){
					vars.part+=vars.step;
					if(settings["writeLast"]&&vars.finalevel==false&&vars.part==vars.max-1){
						print("DANGER");
						vars.save.Seek(vars.line+loc.Length,SeekOrigin.Begin);
						sr = new StreamReader(vars.save);
						line=sr.ReadLine();
						FileStream write = new FileStream(vars.saveDir+"slot0.dta", FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
						write.Seek(vars.line+loc.Length+line.Length-1,SeekOrigin.Begin);
						write.Write(Encoding.ASCII.GetBytes("n"),0,1);
						write.Close();
						vars.finalevel=true;
					}
					if(vars.part>=vars.max){
						vars.part=-1;
						vars.finalevel=false;
					}
					return true;
				}
			}
		}
	}
	vars.lastLoc=loc;
}