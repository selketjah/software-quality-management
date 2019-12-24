module string::Trim

import IO;
import String;

public list[str] stringToTrimmedList(str dataString){
	list[str] dataStringList = ([trim(line) | str line <- split("\n", dataString), size(trim(line)) > 0 ]);
	
	return dataStringList;
}

public str trimTerminalChars(str subject){
	subject = replaceAll(subject,"}", "");
	subject = replaceAll(subject,"{", "");
	
	return subject;
}

public list[str] trimTerminalChars(list[str] subjects){
	return [(trim(trimTerminalChars(subject))) | str subject <- subjects, size((trimTerminalChars(subject))) > 0];
}