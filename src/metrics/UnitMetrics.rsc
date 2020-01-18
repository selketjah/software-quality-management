module metrics::UnitMetrics

import IO;
import lang::java::jdt::m3::AST;
import Set;
import metrics::Volume;
import metrics::Complexity;
import structs::UnitMetrics;
import structs::Volume;

public CompilationUnitMetric calculateUnitMetrics(loc fileLocation, ComponentLOC compilationUnitMap) {
	Declaration declaration = createAstFromEclipseFile(fileLocation, false);
	UnitMetric unitMetric;
	list[UnitMetric] unitMetricCollection = [];
	
	visit(declaration) {
		case method: \method(_, name, _, _, statement): {
			int complexity = calculateUnitCyclomaticComplexity(statement);
			
			unitMetric = <name, method.src, complexity, compilationUnitMap[method.src]>;
			unitMetricCollection += unitMetric;
		}
	}
	
	return <fileLocation, unitMetricCollection>;
}

public map[loc, int] createMethodComplexityMap(set[CompilationUnitMetric] compilationUnitMetricSet){
	map[loc, int] methodComplexityMap = ();
	
	for(tuple[loc file, list[UnitMetric] unitMetric] metric <- compilationUnitMetricSet){
		methodComplexityMap += ( metric.method:metric.complexity | UnitMetric metric <- metric.unitMetric );
	}
	
	return methodComplexityMap;
}
