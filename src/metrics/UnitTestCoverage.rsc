module metrics::UnitTestCoverage
import Exception;
import IO;
import ParseTree;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::std::ASCII;

lexical Assert = "assert"[a-z _ A-Z]+"("![\n]*")" $;
layout Whitespace = [\t\n\r\ ]*;

syntax AssertStatementSyntax
  = Assert;
  
int countAssertsInFile (loc file){
	int count = 0;
	str fileContents = readFile(file);
	list[str] instructions = split(";", fileContents);
	
	list[str] lines= ([ replaceAll(trim(a)," ","") | a <- instructions, /^assert((?![\s])[a-z0-9])*\s*\(.*\).*$/i := trim(a) ]);
	if(size(lines)>0){
		count = sum([((isAssertStatement(line))? 1 : 0) | line <- lines]);
	}

    return count;
}

bool isAssertStatement(str subject){
	try{ 
		pt = parse(#AssertStatementSyntax, subject);
		
		visit (pt) {
	        case (AssertStatementSyntax)`<Assert _>`: return true; 
		}
	} catch ParseError(loc l): {
		println("I found a parse error at line <l.begin.line>, column <l.begin.column> in file <l>");}
	return false;
}