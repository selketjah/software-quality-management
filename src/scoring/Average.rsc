module scoring::Average

import IO;
import Set;
import List;
import Map;
import util::Math;

import metrics::UnitMetrics;
import metrics::Complexity;
import structs::Average;
import structs::UnitMetrics;

private Totals calculateTotals(list[UnitMetric] compilationUnitMetrics) {
	int numberOfUnits = size(compilationUnitMetrics);
	int totalComplexity = 0;
	int totalSize = 0;
	
	for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {
		totalSize += size;
		totalComplexity += complexity;
	}
	
	return <numberOfUnits, totalSize, totalComplexity>;
}

public Average calculateAverages(map[loc, int] methodComplexityMap, set[CompilationUnitMetric] compilationUnitMetrics) {	
	int totalNumberOfUnits = 0;
	int totalComplexity = 0;
	int totalSize = 0;
		
	for(<loc source, list[UnitMetric] compilationUnitMetric> <- compilationUnitMetrics) {
		Totals totals = calculateTotals(compilationUnitMetric);
		
		totalNumberOfUnits += totals.numberOfUnits;
		totalSize += totals.totalSize;
	}
	
	real sizeAverage = toReal(totalSize) / toReal(totalNumberOfUnits);
	
	real complexityAverage =  toReal(calculateTotalComplexity(methodComplexityMap))/totalNumberOfUnits;
	
	return <sizeAverage, complexityAverage>;
}