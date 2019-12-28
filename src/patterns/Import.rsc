module \lexical::Import

import IO;
import ParseTree;
import lang::java::\syntax::Java18;
import String;

bool isImportStatementString(str subject){
	return startsWith(subject, "import ");
}