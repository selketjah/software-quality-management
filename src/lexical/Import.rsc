module \lexical::Import

import IO;
import ParseTree;
import String;

//lexical CustomImport = "import"[a-z _ A-Z]+";" $;
//layout Whitespace = [\t\n\r\ ]*;
//
//syntax CustomImportSyntax
//  = CustomImport;
//
//bool isImportStatement(str subject){
//	try{ 
//		pt = parse(#CustomImportSyntax, subject);
//		
//		visit (pt) {
//	        case CustomImportSyntax: {
//	        	return true;
//	        }
//		}
//	} catch ParseError(loc fLoc): {
//		return false;
//	}
//	return false;
//}

bool isImportStatementString(str subject){
	return contains(subject, "import ");
}

//bool isImportStatementRegex(str subject){
//	return /^import\s.*;$/ := subject;
//}