module metrics::UnitTestCoverage

import Exception;
import IO;
import lang::std::ASCII;
import ParseTree;
import String;

import \lexical::Assert;

alias AssertCount = tuple[loc fileLoc, int count];
  
AssertCount countAssertsInFile (loc fileLoc){
	int count = 0;
	str fileContents = readFile(fileLoc);
	list[str] instructions = split(";", fileContents);
	
	list[str] lines= ([ replaceAll(trim(a)," ","") | a <- instructions, /^assert((?![\s])[a-z0-9])*\s*\(.*\).*$/i := trim(a) ]);
	if(size(lines)>0){
		count = sum([((isAssertStatement(line))? 1 : 0) | line <- lines]);
	}

    return <fileLoc, count>;
}
