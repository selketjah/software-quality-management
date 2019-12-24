module \lexical::Assert

lexical Assert = "assert"[a-z _ A-Z]+"("![\n]*")" $;
layout Whitespace = [\t\n\r\ ]*;

syntax AssertStatementSyntax
  = Assert;
  
public bool isAssertStatement(str subject){
	try{	 
		pt = parse(#AssertStatementSyntax, subject);
		
		visit (pt) {
	        case (AssertStatementSyntax)`<Assert _>`: return true; 
		}
	} catch ParseError(loc fLoc): {
		return false;
	}
	return false;
}