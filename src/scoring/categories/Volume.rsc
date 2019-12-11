module scoring::categories::Volume

import IO;
import String;
import Set;
import List;
import Map;
import util::Math;

import scoring::Rank;


// These bounds are taken from page 34 of the SIG model report
tuple[int lower, int upper] PLUSPLUS_BOUNDS 	= <0, 66000>;
tuple[int lower, int upper] PLUS_BOUNDS 		= <66000, 246000>;
tuple[int lower, int upper] NEUTRAL_BOUNDS 		= <246000, 665000>;
tuple[int lower, int upper] MINUS_BOUNDS 		= <665000, 1310000>;

@doc{
	Calulates the rank level of this metric.

	Parameters:
	- int volume: Lines of code (LOC)
}
Rank calculateVolumeRank(int volume) {
	if (volume < PLUSPLUS_BOUNDS.lower) {
		return Rank::\tbd();
	} else if (volume >= PLUSPLUS_BOUNDS.lower && volume < PLUSPLUS_BOUNDS.upper) {
		return \plusplus();
	} else if (volume >= PLUS_BOUNDS.lower && volume < PLUS_BOUNDS.upper) {
		return \plus();
	} else if (volume >= NEUTRAL_BOUNDS.lower && volume < NEUTRAL_BOUNDS.upper) {
		return \neutral();
	} else if (volume >= MINUS_BOUNDS.lower && volume < MINUS_BOUNDS.upper) {
		return \minus();
	} else {
		return \minusminus();
	}
}
