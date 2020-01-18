module scoring::Percentage

import IO;
import List;
import Map;
import util::Math;

import metrics::Duplicates;
import metrics::UnitTestCoverage;
import structs::Percentage;
import structs::Duplication;
import structs::UnitTestCoverage;

private int determineUnitTestCoveragePercentageRank(int totalComplexity, UnitTestCoverageMap assertMaps) {
	int asserts = 0;
	
	for(loc src <- assertMaps){
		tuple[int numberOfAsserts, int locCoverage, int complexityCoverage] info = assertMaps[src];
		asserts += info.numberOfAsserts;
	}
	println(asserts);
	println(totalComplexity);
	int percentage = percent(asserts, totalComplexity);
	return percentage;
}

private int determineDuplicationPercentage(int volume, DuplicateCodeRel duplicationRel) {
	map[loc, list[int]] dupMaps = (() | it + (src: dup(([]|it+lstIndexes |list[int] lstIndexes <- dupSet))) | <loc src, set[list[int]] dupSet> <- duplicationRel);
	
	int duplications = ( 0 | it + size(dupMaps[src]) | loc src <- dupMaps);
	int percentage = percent(duplications, volume);
	
	return percentage;
}

public Percentages calculatePercentages(int volume, DuplicateCodeRel duplicationRel, int totalComplexity, UnitTestCoverageMap assertMaps) {	
	int duplicationPercentage = determineDuplicationPercentage(volume, duplicationRel);
	int unitTestCoveragePercentage = determineUnitTestCoveragePercentageRank(totalComplexity, assertMaps);

	return <duplicationPercentage, unitTestCoveragePercentage>;
}