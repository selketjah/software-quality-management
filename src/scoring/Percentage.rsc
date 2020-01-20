module scoring::Percentage

import IO;
import List;
import Map;
import util::Math;

import metrics::Duplicates;
import metrics::UnitTestCoverage;
import metrics::Complexity;
import structs::Percentage;
import structs::Duplication;
import structs::UnitTestCoverage;

private int determineUnitTestCoveragePercentageRank(map[loc, int] methodComplexityMap, UnitTestCoverageMap assertMaps) {
	int asserts = 0;
	int unitTestComplexity = 0;
	
	for(loc src <- assertMaps){
		tuple[int numberOfAsserts, int locCoverage, int complexityCoverage] info = assertMaps[src];
		asserts += info.numberOfAsserts;
		unitTestComplexity += methodComplexityMap[src];
		
	}
	//uitgaand van 1 testcase test 1 CC pad
	int totalComplexity = calculateTotalComplexity(methodComplexityMap);
	int percentage = percent(size(assertMaps), totalComplexity - unitTestComplexity);
	return percentage;
}

private int determineDuplicationPercentage(int volume, DuplicateCodeRel duplicationRel) {
	map[loc, list[int]] dupMaps = (() | it + (src: dup(([]|it+lstIndexes |list[int] lstIndexes <- dupSet))) | <loc src, set[list[int]] dupSet> <- duplicationRel);
	
	int duplications = ( 0 | it + size(dupMaps[src]) | loc src <- dupMaps);
	int percentage = percent(duplications, volume);
	
	return percentage;
}

public Percentages calculatePercentages(int volume, DuplicateCodeRel duplicationRel, map[loc, int] methodComplexityMap, UnitTestCoverageMap assertMaps) {	
	int duplicationPercentage = determineDuplicationPercentage(volume, duplicationRel);
	int unitTestCoveragePercentage = determineUnitTestCoveragePercentageRank(methodComplexityMap, assertMaps);

	return <duplicationPercentage, unitTestCoveragePercentage>;
}