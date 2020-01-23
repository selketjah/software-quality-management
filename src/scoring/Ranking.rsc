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
import structs::RiskLevel;
import scoring::Maintainability;
import scoring::categories::Volume;
import scoring::categories::UnitSize;
import scoring::categories::CyclomaticComplexity;
import scoring::categories::Duplication;
import scoring::categories::UnitTestCoverage;
import structs::Rank;
import structs::Ranking;
import structs::Maintainability;
import structs::UnitMetrics;
import structs::Percentage;

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

private tuple[Rank unitSize, Rank complexity] determineCompilationUnitRank(RiskLevelsPercentages riskLevelsPercentages) {
	// group risk levels to determine rank
	tuple[int, int, int] complexityRiskLevels = <riskLevelsPercentages.complexityDivisions[\moderate()] ? 0, riskLevelsPercentages.complexityDivisions[\high()] ? 0, riskLevelsPercentages.complexityDivisions[\veryhigh()] ? 0>;
	tuple[int, int, int] unitSizeRiskLevels = <riskLevelsPercentages.unitSizeDivisions[\moderate()] ? 0, riskLevelsPercentages.unitSizeDivisions[\high()] ? 0, riskLevelsPercentages.unitSizeDivisions[\veryhigh()] ? 0>;
	
	Rank complexityRank = determineComplexityRank(complexityRiskLevels);
	Rank unitSizeRank = determineUnitSizeRank(unitSizeRiskLevels);
	
	return <unitSizeRank, complexityRank>;
}

public Ranks determineRanks(Metrics metrics) {
	Rank volumeRank = determineVolumeRank(metrics.volume);	
	Rank unitTestCoverageRank = determineUnitTestCoverageRank(metrics.percentages.unitTestCoverage);
	
	Rank duplicationRank = determineDuplicationRank(metrics.percentages.duplication);
	tuple[Rank unitSizeRank, Rank unitComplexityRank] compilationUnitRanks = determineCompilationUnitRank(metrics.percentages.unitPercentages);
	
	Rank overallRank = calculateAverageRank([volumeRank, compilationUnitRanks.unitSizeRank, compilationUnitRanks.unitComplexityRank, duplicationRank, unitTestCoverageRank]);
	map[MaintainabilityCharacteristic, Rank] maintainability = determineMaintainabilityModel(volumeRank, compilationUnitRanks.unitSizeRank, compilationUnitRanks.unitComplexityRank, duplicationRank, unitTestCoverageRank);
	
	return <overallRank, maintainability, volumeRank, compilationUnitRanks.unitSizeRank, compilationUnitRanks.unitComplexityRank, duplicationRank, unitTestCoverageRank>;
}