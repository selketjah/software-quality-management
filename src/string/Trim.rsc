module string::Trim

import IO;
import String;

public list[str] stringToTrimmedList(str dataString){
	
	list[str] dataStringList = ([trim(line) | str line <- split("\n", dataString), size(trim(line)) > 0 ]);
	
	return dataStringList;
}