module metrics::Complexity

import Message;
import Set;
import IO;
import String;
import List;
import Map;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Resources;
import analysers::LocAnalyser;
import Relation;
import Set;

alias UnitComplexity = tuple[loc method, int size];
alias ComplicationUnitComplexity = tuple[loc file, list[UnitComplexity] unitComplexities];

//public set[ComplicationUnitComplexity] calculateCyclomaticComplexity(list[loc] fileLocations) {
	
//}

public ComplicationUnitComplexity calculateFileCyclomaticComplexity(loc fileLocation){
	UnitComplexity unitComplexity;
	list[UnitComplexity] unitComplexityCollection = [];
	
	M3 model = createM3FromFile(fileLocation);
	Declaration declaration = createAstFromEclipseFile(fileLocation, false);
	
	visit(declaration) {
		case method: \method(_, name, _, _, statement): {
			int complexity = calculateUnitCyclomaticComplexity(statement);
			println("Method: <name> - Complexity: <complexity>");
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