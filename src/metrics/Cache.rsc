module metrics::Cache
import ValueIO;
import analysis::graphs::Graph;
import IO;
import Set;
import List;
import String;

loc tmpFileLocation = |home://tmp-sqm|;

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
	str path = substring(replaceAll(src.path, "/","-"),1)+"-<src.begin.line>-<src.end.line>.txt";
	loc tmpFile = tmpFileLocation + path;
	return tmpFile;
}