module metrics::UnitMetrics

import IO;
import lang::java::jdt::m3::AST;

import metrics::Volume;
import metrics::Complexity;

alias UnitMetric = tuple[str name, loc method, int complexity, int size];
alias CompilationUnitMetric =  tuple[loc file, list[UnitMetric] unitMetric];

public CompilationUnitMetric calculateUnitMetrics(loc fileLocation) {
	Declaration declaration = createAstFromFile(fileLocation, false);
	UnitMetric unitMetric;
	list[UnitMetric] unitMetricCollection = [];
	
	visit(declaration) {
		case method: \method(_, name, _, _, statement): {
			int complexity = calculateUnitCyclomaticComplexity(statement);
			int size = calculateUnitVolume(method.src);			
			unitMetric = <name, method.src, complexity, size>;
			unitMetricCollection += unitMetric;
		}
	}
	
	return <fileLocation, unitMetricCollection>;
}
