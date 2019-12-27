module scoring::Average

import IO;
import Set;
import List;
import Map;
import util::Math;

import metrics::UnitMetrics;

alias Average = tuple[int size, int complexity];
alias Totals = tuple[int numberOfUnits, int totalSize, int totalComplexity];

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

public Average calculateAverages(set[CompilationUnitMetric] compilationUnitMetrics) {	
	int totalNumberOfUnits = 0;
	int totalComplexity = 0;
	int totalSize = 0;
		
	for(<loc source, list[UnitMetric] compilationUnitMetric> <- compilationUnitMetrics) {
		Totals totals = calculateTotals(compilationUnitMetric);
		
		totalNumberOfUnits += totals.numberOfUnits;
		totalComplexity += totals.totalComplexity;
		totalSize += totals.totalSize;
	}
	
	int sizeAverage = percent(totalSize, totalNumberOfUnits);
	int complexityAverage =  percent(totalComplexity, totalNumberOfUnits);
	
	return <sizeAverage, complexityAverage>;
}