module scoring::Percentage

import IO;
import List;
import Map;
import util::Math;

import metrics::Duplicates;
import metrics::UnitTestCoverage;

alias Percentages = tuple[int duplication, int unitTestCoverage];

private int determineUnitTestCoveragePercentageRank(int volume, UnitTestCoverageMap assertMaps) {
	int asserts = 0;
	
	for(loc src <- assertMaps){
		tuple[int numberOfAsserts, int locCoverage, int complexityCoverage] info = assertMaps[src];
		asserts += info.numberOfAsserts;
	}
	
	int percentage = percent(asserts, volume);
	return percentage;
}

private int determineDuplicationPercentage(int volume, DuplicateCodeRel duplicationRel) {
	map[loc, list[int]] dupMaps = (() | it + (src: dup(([]|it+lstIndexes |list[int] lstIndexes <- dupSet))) | <loc src, set[list[int]] dupSet> <- duplicationRel);
	
	int duplications = ( 0 | it + size(dupMaps[src]) | loc src <- dupMaps);
	int percentage = percent(duplications, volume);
	
	return percentage;
}

public Percentages calculatePercentages(int volume, DuplicateCodeRel duplicationRel, UnitTestCoverageMap assertMaps) {	
	int duplicationPercentage = determineDuplicationPercentage(volume, duplicationRel);
	int unitTestCoveragePercentage = determineUnitTestCoveragePercentageRank(volume, assertMaps);

	return <duplicationPercentage, unitTestCoveragePercentage>;
}