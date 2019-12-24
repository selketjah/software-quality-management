module collections::Filter

import List;
import \lexical::Import;

public list[str] removeImports(list[str] stringList){
	return [line | str line <- (stringList), (!isImportStatementString(line))];
}