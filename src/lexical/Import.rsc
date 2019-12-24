module \lexical::Import

import IO;
import ParseTree;
import lang::java::\syntax::Java18;

bool isImportStatement(str subject){
	try{ 
		pt = parse(#ImportDeclaration, subject);
		
		visit (pt) {
	        case ImportDeclaration: {
	        	return true;
	        }
		}
	} catch ParseError(loc fLoc): {
		return false;
	}
	return false;
}