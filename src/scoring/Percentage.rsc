module scoring::Percentage

import IO;
import List;
import Map;
import util::Math;

import metrics::Duplicates;
import metrics::UnitTestCoverage;
import metrics::Complexity;
import scoring::categories::CyclomaticComplexity;
import scoring::categories::UnitSize;
import structs::Percentage;
import structs::Duplication;
import structs::UnitTestCoverage;
import structs::UnitMetrics;
import structs::RiskLevel;

private RiskLevelsPercentages determineCompilationUnitPercentages(set[CompilationUnitMetric] compilationUnitMetricsSet) {
	int totalSize = 0;
	map[RiskLevel risks, int _] complexityRiskLevelMap = ();
	map[RiskLevel risks, int _] unitSizeRiskLevelMap = ();

	for(<loc source, list[UnitMetric] compilationUnitMetrics> <- compilationUnitMetricsSet) {
		for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {
			totalSize += size;
			
			RiskLevel complexityRiskLevel = determineRiskLevelForUnitComplexity(complexity);
			complexityRiskLevelMap[complexityRiskLevel] ? 0 += size;
			
			RiskLevel unitSizeRiskLevel = determineRiskLevelForUnitSize(size);
			unitSizeRiskLevelMap[unitSizeRiskLevel] ? 0 += size;
		}
	}
	
	// calculate percentage per risk level
	map[RiskLevel risks, int percentages] complexityDivisions = (risk : percent(complexityRiskLevelMap[risk], totalSize) | risk <- complexityRiskLevelMap.risks);
	map[RiskLevel risks, int percentages] unitSizeDivisions = (risk : percent(unitSizeRiskLevelMap[risk], totalSize) | risk <- unitSizeRiskLevelMap.risks);
	
	return <complexityDivisions, unitSizeDivisions>;
}

private int determineUnitTestCoveragePercentageRank(map[loc, int] methodComplexityMap, UnitTestCoverageMap assertMaps) {
	int asserts = 0;
	int unitTestComplexity = 0;
	
	for(loc src <- assertMaps){
		UnitTestCoverage info = assertMaps[src];
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

public Percentages calculatePercentages(int volume, set[CompilationUnitMetric] compilationUnitMetricsSet, DuplicateCodeRel duplicationRel, map[loc, int] methodComplexityMap, UnitTestCoverageMap assertMaps) {	
	int duplicationPercentage = determineDuplicationPercentage(volume, duplicationRel);
	int unitTestCoveragePercentage = determineUnitTestCoveragePercentageRank(methodComplexityMap, assertMaps);
	RiskLevelsPercentages riskLevelPercentages = determineCompilationUnitPercentages(compilationUnitMetricsSet);

	return <duplicationPercentage, unitTestCoveragePercentage, riskLevelPercentages>;
}