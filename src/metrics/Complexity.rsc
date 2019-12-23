module metrics::Complexity

import IO;
import lang::java::jdt::m3::AST;

alias UnitComplexity = tuple[str method, int size];
alias CompilationUnitComplexity = tuple[loc file, list[UnitComplexity] unitComplexities];

public CompilationUnitComplexity calculateFileCyclomaticComplexity(loc fileLocation){
	UnitComplexity unitComplexity;
	list[UnitComplexity] unitComplexityCollection = [];
	
	Declaration declaration = createAstFromEclipseFile(fileLocation, false);
	
	visit(declaration) {
		case method: \method(_, name, _, _, statement): {
			int complexity = calculateUnitCyclomaticComplexity(statement);
			unitComplexity = <name, complexity>;
			unitComplexityCollection += unitComplexity;
		}
	}
	
	return <fileLocation, unitComplexityCollection>;
}

public int calculateUnitCyclomaticComplexity(Statement statement) {
	// https://stackoverflow.com/questions/40064886/obtaining-cyclomatic-complexity

	int total = 1; // base is 1
	visit(statement) {
		case \if(_, _): total += 1;
     	case \if(_, _, _): total += 1;
     	case \infix(_, "||", _): total += 1;
     	case \infix(_, "&&", _): total += 1;
     	case \foreach(_, _, _): total += 1;
     	case \for(_, _, _, _): total += 1;
     	case \for(_, _, _): total += 1;
     	case \case(_): total += 1;
     	case \defaultCase(): total += 1;
     	case \while(_, _): total += 1;
     	case \do(_, _): total += 1;
     	case \catch(_,_): total += 1;
        case \conditional(_,_,_): total += 1;
	};
	
	return total;
}