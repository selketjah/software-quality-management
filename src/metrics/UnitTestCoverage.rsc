module metrics::UnitTestCoverage

import Exception;
import IO;
import lang::java::m3::Core;
import lang::std::ASCII;
import ParseTree;
import String;

import metrics::Volume;

alias UnitTestCoverageMap = map[loc, tuple[int numberOfAsserts, int locCoverage]];

public UnitTestCoverageMap createUnitTestCoverageMap(ComponentLOC methodSizeRel, rel[loc name,loc src] methods,map[loc src, list[str] linesOfCode]  compilationUnitMap, M3 model){
	UnitTestCoverageMap testCoverageMap = ();
	for(<loc name, loc src> <- methods){
		//println(compilationUnitMap[src].content);
		int numberOfAsserts = (0 | it +1 |str locStr <- compilationUnitMap[src], /assert[a-zA-Z]+\s*[\(].*[\)]/ := locStr);
		 
		if(numberOfAsserts > 0){
			int size = calculateInvokedLinesOfCode(name, methodSizeRel, model);
			
			testCoverageMap += (src: <numberOfAsserts, size>);
		}
	}
	
	return testCoverageMap;
}