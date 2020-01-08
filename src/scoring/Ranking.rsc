module scoring::Ranking

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import metrics::UnitMetrics;

import scoring::Rank;
import scoring::Percentage;
import scoring::RiskLevel;
import scoring::Maintainability;
import scoring::categories::Volume;
import scoring::categories::UnitSize;
import scoring::categories::CyclomaticComplexity;
import scoring::categories::Duplication;
import scoring::categories::UnitTestCoverage;

alias Metrics = tuple[int volume, set[CompilationUnitMetric] compilationUnitMetrics, Percentages percentages];
alias Ranks = tuple[Rank overall, map[MaintainabilityCharacteristic, Rank] maintainability, Rank volume, Rank unitSize, Rank complexity, Rank duplication, Rank unitTestCoverage];

private Rank determineOverallRank(Rank volume, Rank unitSize, Rank unitComplexity, Rank duplication, Rank unitTestCoverage) {
	list[Rank] overall = [];
	overall += volume;
	overall += unitSize;
	overall += unitComplexity;
	overall += duplication;
	overall += unitTestCoverage;
	
	Rank rank = calculateAverageRank(overall);
	return rank;
}

private map[MaintainabilityCharacteristic, Rank] determineMaintainabilityModel(Rank volumeRank, Rank unitSizeRank, Rank unitComplexityRank, Rank duplicationRank, Rank unitTestCoverageRank) {
	return (
		\analysability(): calculateAverageRank([volumeRank, duplicationRank, unitSizeRank, unitTestCoverageRank]),
		\changeability(): calculateAverageRank([unitComplexityRank, duplicationRank]),
		\stability(): unitTestCoverageRank,
		\testability(): calculateAverageRank([unitComplexityRank, unitSizeRank, unitTestCoverageRank])
	);
}

private tuple[Rank unitSize, Rank complexity] determineCompilationUnitRank(int volume, set[CompilationUnitMetric] compilationUnitMetricsSet) {
	int totalNumberOfUnits = 0;
	map[RiskLevel risks, int _] complexityRiskLevelMap = ();
	map[RiskLevel risks, int _] unitSizeRiskLevelMap = ();

	for(<loc source, list[UnitMetric] compilationUnitMetrics> <- compilationUnitMetricsSet) {
		int numberOfUnits = size(compilationUnitMetrics);
		totalNumberOfUnits += numberOfUnits;
		
		for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {
			RiskLevel complexityRiskLevel = determineRiskLevelForUnitComplexity(complexity);
			complexityRiskLevelMap[complexityRiskLevel] ? 0 += size;
			
			RiskLevel unitSizeRiskLevel = determineRiskLevelForUnitSize(size);
			unitSizeRiskLevelMap[unitSizeRiskLevel] ? 0 += size;
		}
	}
	
	// calculate percentage per risk level
	map[RiskLevel risks, int percentages] complexityDivisions = (risk : percent(complexityRiskLevelMap[risk], totalNumberOfUnits) | risk <- complexityRiskLevelMap.risks);
	map[RiskLevel risks, int percentages] unitSizeDivisions = (risk : percent(unitSizeRiskLevelMap[risk], totalNumberOfUnits) | risk <- unitSizeRiskLevelMap.risks);
	
	// group risk levels to determine rank
	tuple[int, int, int] complexityRiskLevels = <complexityDivisions[\moderate()] ? 0, complexityDivisions[\high()] ? 0, complexityDivisions[\veryhigh()] ? 0>;
	tuple[int, int, int] unitSizeRiskLevels = <unitSizeDivisions[\moderate()] ? 0, unitSizeDivisions[\high()] ? 0, unitSizeDivisions[\veryhigh()] ? 0>;
	
	println("Complexity risk levels: <complexityRiskLevels> ");
	println("Unit size risk levels: <unitSizeRiskLevels> ");
	
	Rank complexityRank = determineComplexityRank(complexityRiskLevels);
	Rank unitSizeRank = determineUnitSizeRank(unitSizeRiskLevels);
	
	return <unitSizeRank, complexityRank>;
}

public Ranks determineRanks(Metrics metrics) {
	Rank volumeRank = determineVolumeRank(metrics.volume);	
	Rank unitTestCoverageRank = determineUnitTestCoverageRank(metrics.percentages.unitTestCoverage);
	
	Rank duplicationRank = determineDuplicationRank(metrics.percentages.duplication);
	tuple[Rank unitSizeRank, Rank unitComplexityRank] compilationUnitRanks = determineCompilationUnitRank(metrics.volume, metrics.compilationUnitMetrics);
	
	Rank overallRank = calculateAverageRank([volumeRank, compilationUnitRanks.unitSizeRank, compilationUnitRanks.unitComplexityRank, duplicationRank, unitTestCoverageRank]);
	map[MaintainabilityCharacteristic, Rank] maintainability = determineMaintainabilityModel(volumeRank, compilationUnitRanks.unitSizeRank, compilationUnitRanks.unitComplexityRank, duplicationRank, unitTestCoverageRank);
	
	return <overallRank, maintainability, volumeRank, compilationUnitRanks.unitSizeRank, compilationUnitRanks.unitComplexityRank, duplicationRank, unitTestCoverageRank>;
}