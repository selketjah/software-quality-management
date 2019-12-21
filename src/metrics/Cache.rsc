module metrics::Cache

import analysis::graphs::Graph;
import IO;
import String;
import ValueIO;

import structs::Duplicates;

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

public void cacheDupliccateData(set[DuplicatePairs] duplicateData){
	loc tmpFileLocation = tmpLocation + "duplication-data.sqm";
	writeTextValueFile(tmpFileLocation, duplicateData);
}

public set[DuplicatePairs] getDuplicateDataFromCache(){
	loc tmpFileLocation = tmpLocation + "duplication-data.sqm";
	return readTextValueFile(#list[str],tmpFileLocation);
}

private loc getTmpFileLocationFromLocRef(loc src){
	
	//str path = substring(replaceAll(src.path, "/","-"),1)+"-<src.begin.line>-<src.end.line>.txt";
	str path = substring(replaceAll(src.path, "/","-"),1)+".sqm";
	loc tmpFile = tmpFileLocation + path;
	//get full path on local machine
	println(tmpFile);
	return tmpFile;
}