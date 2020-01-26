module metrics::Complexity

import IO;
import Set;
import List;
import Map;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

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

public int calculateTotalComplexity(map[loc, int] methodComplexityMap){
	int currentComplexity = 0;
	for(loc src <- methodComplexityMap){
		currentComplexity += methodComplexityMap[src]; 
	}
	
	return currentComplexity - (size(methodComplexityMap)-1); // +1 == program execution
}

