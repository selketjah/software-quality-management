module scoring::categories::Duplication

import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::Rank;

// These risk bounds and ranking are taken from page 6 of the 'A Practical Model for Measuring Maintainability' paper
tuple[int lower, int upper] PLUSPLUS_BOUNDS = <0, 3>;
tuple[int lower, int upper] PLUS_BOUNDS = <3, 5>;
tuple[int lower, int upper] NEUTRAL_BOUNDS = <5, 10>;
tuple[int lower, int upper] MINUS_BOUNDS = <10, 20>;

public Rank determineDuplicationRank(int duplicationPercentage) {
	if (duplicationPercentage >= PLUSPLUS_BOUNDS.lower && duplicationPercentage < PLUSPLUS_BOUNDS.upper) {
		return \plusplus();
	} else if (duplicationPercentage >= PLUS_BOUNDS.lower && duplicationPercentage < PLUS_BOUNDS.upper) {
		return \plus();
	} else if (duplicationPercentage >= NEUTRAL_BOUNDS.lower && duplicationPercentage < NEUTRAL_BOUNDS.upper) {
		return \neutral();
	} else if (duplicationPercentage >= MINUS_BOUNDS.lower && duplicationPercentage < MINUS_BOUNDS.upper) {
		return \minus();
	} else {
		return \minusminus();
	}
}