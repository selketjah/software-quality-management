module metrics::UnitTestCoverage

import Exception;
import Map;
import IO;
import lang::java::m3::Core;
import lang::std::ASCII;
import ParseTree;
import String;
import metrics::UnitMetrics;
import metrics::Volume;
import metrics::Complexity;
import structs::UnitTestCoverage;
import structs::Volume;

public UnitTestCoverageMap createUnitTestCoverageMap(ComponentLOC methodSizeRel, rel[loc name,loc src] methods,map[loc src, list[str] linesOfCode]  compilationUnitMap, map[loc, int] methodComplexityMap, M3 model){
	//we should check what complexity is directly affected by a set of assert statements
	UnitTestCoverageMap testCoverageMap = ();
	
	int size=0;
		
	for(<loc name, loc src> <- methods) {
		int numberOfAsserts = (0 | it +1 |str locStr <- compilationUnitMap[src], /assert[a-zA-Z]+\s*[\(].*[\)]/ := locStr);
		 
		if(numberOfAsserts > 0){
			int locCoverage = calculateInvokedLinesOfCode(name, methodSizeRel, model);
			tuple[list[loc] methodCalls, int totalComplexity] complexityCoverage = calculateInvokedComplexity(name, methodComplexityMap, model);
			testCoverageMap += (src: <name, numberOfAsserts, complexityCoverage.methodCalls, locCoverage, complexityCoverage.totalComplexity>);
		}
	}
	
	return testCoverageMap;
}