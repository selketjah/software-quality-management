module \lexical::Import

import IO;
import ParseTree;
import lang::java::\syntax::Java15;

bool isImportStatement(str subject){
	try{ 
		pt = parse(#ImportDec, subject);
		
		visit (pt) {
	        case ImportDec: {
	        	return true;
	        }
		}
	} catch ParseError(loc fLoc): {
		return false;
	}
	return false;
}