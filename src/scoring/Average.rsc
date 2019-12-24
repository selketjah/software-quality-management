module scoring::Average


import metrics::UnitMetrics;

alias Average = tuple[real size, real complexity];
alias Totals = tuple[int numberOfUnits, int totalSize, int totalComplexity];

private Totals calculateTotals(list[CompilationUnitMetric] compilationUnitMetrics) {
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
		
	for(<loc source, list[CompilationUnitMetric] compilationUnitMetric> <- compilationUnitMetrics) {
		Totals totals = calculateTotals(compilationUnitMetric);
		
		totalNumberOfUnits += totals.numberOfUnits;
		totalComplexity += totals.totalComplexity;
		totalSize += totals.totalSize;
	}
	
	real sizeAverage = totalSize / totalNumberOfUnits;
	real complexityAverage = totalComplexity / totalNumberOfUnits;
	
	return <sizeAverage, complexityAverage>;
}