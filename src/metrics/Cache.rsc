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

public void cacheDupliccateData(DuplicateLocMap duplicateData){
	loc tmpFileLocation = tmpFileLocation + "duplication-data.sqm";
	writeTextValueFile(tmpFileLocation, duplicateData);
}

public DuplicateLocMap getDuplicateDataFromCache(){
	loc tmpFileLocation = tmpFileLocation + "duplication-data.sqm";
	if(exists(tmpFileLocation)){
		return readTextValueFile(#map[real, tuple[str code, list[loc] locations]],tmpFileLocation);
	}else{
		return ();
	}
}

private loc getTmpFileLocationFromLocRef(loc src){
	
	//str path = substring(replaceAll(src.path, "/","-"),1)+"-<src.begin.line>-<src.end.line>.txt";
	str path = substring(replaceAll(src.path, "/","-"),1)+".sqm";
	loc tmpFile = tmpFileLocation + path;
	//get full path on local machine
	println(tmpFile);
	return tmpFile;
}