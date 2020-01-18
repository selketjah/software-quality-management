module visualization::Charts::Treemapping

import metrics::UnitMetrics;

import scoring::categories::CyclomaticComplexity;
import scoring::categories::UnitSize;
import structs::RiskLevel;
import structs::UnitMetrics;

import structs::Visualization;

import vis::Figure;
import vis::Render;

FProperty classColor = fillColor(rgb(197,247,240));

FProperty simpleBoundColor = fillColor(rgb(169,194,201));
FProperty moderateBoundColor = fillColor(rgb(142,140,163));
FProperty highBoundColor = fillColor(rgb(114,87,124));
FProperty veryHighBoundColor = fillColor(rgb(86,33,85));

FProperty classArea = area(40);

FProperty simpleBoundArea = area(3);
FProperty moderateBoundArea = area(7);
FProperty highBoundArea = area(11);
FProperty veryHighBoundArea = area(15);

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

public Figure createUnitSizeBox(int unitSize) {
	RiskLevel riskLevel = determineRiskLevelForUnitSize(unitSize);
	
	FProperty color = getColor(riskLevel);
	FProperty area = getArea(riskLevel);
	
	return box(area, color);
}

public Figure createCompilationBox(Panel active, list[UnitMetric] compilationUnitMetrics) {
	Figures figures = [];
	
	for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {
		Figure figure;
		visit(active) {
			case \complexity(): figure = createComplexityBox(complexity);
			default: figure = createUnitSizeBox(size);		
		}
		figures += figure;
	}
	
	return box(treemap(figures) ,shrink(0.9), classArea, classColor);
}

public Figure drawTreemap(Panel active, set[CompilationUnitMetric] compilationUnitMetricsSet) {	
	Figures figures = [];
	
	for(<loc source, list[UnitMetric] compilationUnitMetrics> <- compilationUnitMetricsSet) {
		fileBox = createCompilationBox(active, compilationUnitMetrics);
		figures += fileBox;
	}

	t = treemap(figures);
	     
	return t;
}

