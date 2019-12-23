module tests::Duplication

import IO;
import List;
import util::Math;
import String;
import List;
import Map;
import ListRelation;

import string::Trim;
import metrics::Volume;

import metrics::Duplicates;

public test bool longestListSubStringTest(){
	
	loc firstSrc = |project://sqm-assignment/src/tests/data/Style.java|;
	loc secondSrc = |project://sqm-assignment/src/tests/data/TextItem.java|;

	map[real, tuple[list[loc] locations, list[str] originalCode]] duplicateLocations = listClonesIn(firstSrc, secondSrc);
 	
 	return size([size(duplicateLocations[ind].locations) | real ind <- duplicateLocations]) == 1;
}
