module metrics::UnitMetrics

import IO;
import lang::java::jdt::m3::AST;
import Set;
import metrics::Volume;
import metrics::Complexity;

alias UnitMetric = tuple[str name, loc method, int complexity, int size];
alias CompilationUnitMetric =  tuple[loc file, list[UnitMetric] unitMetric];

public CompilationUnitMetric calculateUnitMetrics(loc fileLocation, ComponentLOC compilationUnitMap) {
	Declaration declaration = createAstFromEclipseFile(fileLocation, false);
	UnitMetric unitMetric;
	list[UnitMetric] unitMetricCollection = [];
	
	visit(declaration) {
		case method: \method(_, name, _, _, statement): {
			int complexity = calculateUnitCyclomaticComplexity(statement);
			
			unitMetric = <name, method.src, complexity, toList(compilationUnitMap[method.src])[0]-2>;
			unitMetricCollection += unitMetric;
		}
	}
	
	return <fileLocation, unitMetricCollection>;
}

