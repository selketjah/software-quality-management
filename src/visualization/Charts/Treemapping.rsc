module visualization::Charts::Treemapping

import metrics::UnitMetrics;

import scoring::categories::CyclomaticComplexity;
import scoring::RiskLevel;

import vis::Figure;
import vis::Render;

FProperty classColor = fontColor(rgb(197,247,240));

FProperty simpleBoundColor = fontColor(rgb(169,194,201));
FProperty moderateBoundColor = fontColor(rgb(142,140,163));
FProperty highBoundColor = fontColor(rgb(114,87,124));
FProperty veryHighBoundColor = fontColor(rgb(86,33,85));

FProperty classArea = area(40);

FProperty simpleBoundArea = area(5);
FProperty moderateBoundArea = area(10);
FProperty highBoundArea = area(15);
FProperty veryHighBoundArea = area(20);

public FProperty getColor(RiskLevel riskLevel) {
	FProperty color;
	visit(riskLevel) {
		case \simple(): color = simpleBoundColor;
    	case \moderate(): color = moderateBoundColor;
    	case \high(): color = highBoundColor;
    	case \veryhigh(): color = veryHighBoundColor;
    	case \tbd(): color = simpleBoundColor;
	}
	return color;
}

public FProperty getArea(RiskLevel riskLevel){
	FProperty area;
	visit(riskLevel) {
		case \simple(): area = simpleBoundArea;
    	case \moderate(): area = moderateBoundArea;
    	case \high(): area = highBoundArea;
    	case \veryhigh(): area = veryHighBoundArea;
    	case \tbd(): area = simpleBoundArea;
	}
	return area;
}

public Figure createComplexityBox(int complexity) {
	RiskLevel riskLevel = determineRiskLevelForUnitComplexity(complexity);
	
	FProperty color = getColor(riskLevel);
	FProperty area = getArea(riskLevel);
	
	return box(area, color);
}

public Figure createCompilationBox(list[UnitMetric] compilationUnitMetrics) {
	Figures figures = [];
	
	for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {
			complexityBox = createComplexityBox(complexity);
			figures += complexityBox;
	}
	
	return box(treemap(figures) ,shrink(0.9), classArea, classColor);
}

public Figure drawTreemap(set[CompilationUnitMetric] compilationUnitMetricsSet) {	
	Figures figures = [];
	
	for(<loc source, list[UnitMetric] compilationUnitMetrics> <- compilationUnitMetricsSet) {
		fileBox = createCompilationBox(compilationUnitMetrics);
		figures += fileBox;
	}

	t = treemap(figures);
	     
	return t;
}

