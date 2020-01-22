module metrics::UnitTestCoverage

import Exception;
import Map;
import Set;
import IO;
import lang::java::m3::Core;
import lang::std::ASCII;
import ParseTree;
import String;
import metrics::UnitMetrics;
import metrics::Volume;
import structs::UnitTestCoverage;
import structs::Volume;
import util::Editors;


public UnitTestCoverageMap createUnitTestCoverageMap(ComponentLOC methodSizeRel, rel[loc name,loc src] methods,map[loc src, list[str] linesOfCode]  compilationUnitMap, map[loc, int] methodComplexityMap, M3 model){
	//we should check what complexity is directly affected by a set of assert statements
	UnitTestCoverageMap testCoverageMap = ();
	
	int size=0;
		
	for(<loc name, loc src> <- methods) {
		int numberOfAsserts = calculateNumberOfAssertStatements(src, compilationUnitMap);
		 
		if(numberOfAsserts > 0){
			int locCoverage = calculateInvokedLinesOfCode(name, methodSizeRel, model);
			tuple[list[loc] methodCalls, int totalComplexity] complexityCoverage = calculateInvokedComplexity(name, methodComplexityMap, compilationUnitMap, model);
			testCoverageMap += (src: <name, numberOfAsserts, complexityCoverage.methodCalls, locCoverage, complexityCoverage.totalComplexity>);
		}
	}
	
	return testCoverageMap;
}


public int calculateNumberOfAssertStatements(loc src, map[loc src, list[str] linesOfCode]  compilationUnitMap){
	return (0 | it +1 |str locStr <- compilationUnitMap[src], isAssertStatement(locStr));
}

public tuple[list[loc] methodCalls, int totalComplexity] calculateInvokedComplexity(loc src, map[loc, int] methodComplexityMap, map[loc src, list[str] linesOfCode]  compilationUnitMap, M3 model){
	int complexity =0;
	list[loc] methodCalls=[];
	for(loc methodInvocationLocation <- model.methodInvocation[src]){
		//get method location
		set[loc] methodLocationSet = model.declarations[methodInvocationLocation];
		
		if(!isEmpty(methodLocationSet)){
			loc methodLocation = min(methodLocationSet);
			if(methodLocation in methodComplexityMap && calculateNumberOfAssertStatements(methodLocation, compilationUnitMap) == 0){
					complexity += methodComplexityMap[methodLocation];
				
			}
		}
	}
	
	return <methodCalls, complexity - (size(methodCalls) - 1)>;
}

private bool isAssertStatement(str subject){
	return /assert[a-zA-Z]+\s*[\(].*[\)]/ := subject;
}