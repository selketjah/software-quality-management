module scoring::categories::CyclomaticComplexity

import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::Rank;
import structs::RiskLevel;
import structs::Rank;

// These risk bounds and ranking are taken from page 6 of the 'A Practical Model for Measuring Maintainability'

// classification of each unit individually
// very high is everything considered untestable, which is > 50
tuple[int lower, int upper] SIMPLE_BOUNDS = <1, 10>;
tuple[int lower, int upper] MODERATE_BOUNDS = <11, 20>;
tuple[int lower, int upper] HIGH_BOUNDS = <21, 50>;

// classification for entire project, based on % present of previous bounds
// anything above <50, 15, 5> is considered --
tuple[int moderate, int high, int veryHigh] PLUSPLUS_BOUNDS = <25, 0, 0>;
tuple[int moderate, int high, int veryHigh] PLUS_BOUNDS = <30, 5, 0>;
tuple[int moderate, int high, int veryHigh] NEUTRAL_BOUNDS = <40, 10, 0>;
tuple[int moderate, int high, int veryHigh] MINUS_BOUNDS = <50, 15, 5>;

public RiskLevel determineRiskLevelForUnitComplexity(int cyclomaticComplexity) {
	if (cyclomaticComplexity < SIMPLE_BOUNDS.lower) {
		return RiskLevel::\tbd();
	} else if (cyclomaticComplexity >= SIMPLE_BOUNDS.lower && cyclomaticComplexity <= SIMPLE_BOUNDS.upper) {
		return \simple();
	} else if (cyclomaticComplexity >= MODERATE_BOUNDS.lower && cyclomaticComplexity <= MODERATE_BOUNDS.upper) {
		return \moderate();
	} else if (cyclomaticComplexity >= HIGH_BOUNDS.lower && cyclomaticComplexity <= HIGH_BOUNDS.upper) {
		return \high();
	} else {
		return \veryhigh();
	}
}

public Rank determineComplexityRank(tuple[int moderate, int high, int veryHigh] riskLevelPercentage) {
	if(riskLevelPercentage.moderate <= PLUSPLUS_BOUNDS.moderate && riskLevelPercentage.high == PLUSPLUS_BOUNDS.high && riskLevelPercentage.veryHigh == PLUSPLUS_BOUNDS.veryHigh) {
		return \plusplus();
	} else if (riskLevelPercentage.moderate <= PLUS_BOUNDS.moderate && riskLevelPercentage.high <= PLUS_BOUNDS.high && riskLevelPercentage.veryHigh == PLUS_BOUNDS.veryHigh) {
		return \plus();
	} else if (riskLevelPercentage.moderate <= NEUTRAL_BOUNDS.moderate && riskLevelPercentage.high <= NEUTRAL_BOUNDS.high && riskLevelPercentage.veryHigh == NEUTRAL_BOUNDS.veryHigh) {
		return \neutral();
	} else if (riskLevelPercentage.moderate <= MINUS_BOUNDS.moderate && riskLevelPercentage.high <= MINUS_BOUNDS.high && riskLevelPercentage.veryHigh <= MINUS_BOUNDS.veryHigh) {
		return \minus();
	} else {
		return \minusminus();
	}
}