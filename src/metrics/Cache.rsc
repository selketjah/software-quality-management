module metrics::Cache
import ValueIO;
import analysis::graphs::Graph;
import IO;
import String;

loc tmpFileLocation = |tmp:///sqm|;

public void store(loc src,list[str] dataCollection){
	loc tmpFileLocation = getTmpFileLocationFromLocRef(src);
	writeTextValueFile(tmpFileLocation, dataCollection);
}

public list[str] read(loc src) {
   loc tmpFileLocation = getTmpFileLocationFromLocRef(src);
   list[str] fileDataList = readTextValueFile(#list[str],tmpFileLocation);
   
   return fileDataList;
}

private loc getTmpFileLocationFromLocRef(loc src){
	
	//str path = substring(replaceAll(src.path, "/","-"),1)+"-<src.begin.line>-<src.end.line>.txt";
	str path = substring(replaceAll(src.path, "/","-"),1)+".txt";
	loc tmpFile = tmpFileLocation + path;
	//get full path on local machine
	println(tmpFile);
	return tmpFile;
}