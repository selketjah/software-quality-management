module string::Trim

import String;

public list[str] stringToTrimmedList(str dataString){
	return ([trim(line) | str line <- split("\n", dataString), size(trim(line)) > 0 ]);
}