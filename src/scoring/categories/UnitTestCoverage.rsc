module scoring::categories::UnitTestCoverage

import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::Rank;

// These ranking bounds are taken from page 7 of the 'A Practical Model for Measuring Maintainability'
tuple[int lower, int upper] PLUSPLUS_BOUNDS = <95, 100>;
tuple[int lower, int upper] PLUS_BOUNDS = <80, 95>;
tuple[int lower, int upper] NEUTRAL_BOUNDS = <60, 80>;
tuple[int lower, int upper] MINUS_BOUNDS = <20, 60>;

public Rank determineUnitTestCoverageRank(int unitTestCoveragePercentage) {
	if(unitTestCoveragePercentage >= PLUSPLUS_BOUNDS.lower && unitTestCoveragePercentage < PLUSPLUS_BOUNDS.upper) {
		return \plusplus();
	} else if (unitTestCoveragePercentage >= PLUS_BOUNDS.lower && unitTestCoveragePercentage < PLUS_BOUNDS.upper) {
		return \plus();
	} else if (unitTestCoveragePercentage >= NEUTRAL_BOUNDS.lower && unitTestCoveragePercentage < NEUTRAL_BOUNDS.upper) {
		return \neutral();
	} else if (unitTestCoveragePercentage >= MINUS_BOUNDS.lower && unitTestCoveragePercentage < MINUS_BOUNDS.upper) {
		return \minus();
	} else {
		return \minusminus();
	}
}