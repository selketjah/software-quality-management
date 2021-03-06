module visualization::Charts::Treemapping

import IO;
import util::Math;
import util::Editors;

import metrics::UnitMetrics;
import vis::KeySym;
import visualization::Utils;

import scoring::categories::CyclomaticComplexity;
import scoring::categories::UnitSize;
import structs::RiskLevel;
import structs::UnitMetrics;

import structs::Visualization;
import visualization::Visualization;
import visualization::Utils;

import vis::Figure;
import vis::Render;

FProperty classColor = fillColor(rgb(197,247,240));
FProperty classArea = area(40);

FProperty simpleBoundArea = area(5);
FProperty moderateBoundArea = area(10);
FProperty highBoundArea = area(15);
FProperty veryHighBoundArea = area(20);

FProperty popup(str methodName, int complexity, int unitSize) {
	methodName = text(methodName);
	complexity = text("Complexity: <toString(complexity)>");
	unitSize = text("Unit size: <toString(unitSize)>");
	clickText = text("click to view source...", left());
	message = vcat([ methodName, complexity, unitSize, clickText ]);
	
	return mouseOver(box(message, resizable(false),gap(5), startGap(true), endGap(true), size(100, 100)));
}

public FProperty getComplexityColor(RiskLevel riskLevel) {
	FProperty color;
	visit(riskLevel) {
		case \simple(): color = fillColor(rgb(169,194,201));
    	case \moderate(): color = fillColor(rgb(142,140,163));
    	case \high(): color = fillColor(rgb(114,87,124));
    	case \veryhigh(): color = fillColor(rgb(86,33,85));
    	case \tbd(): color = fillColor(rgb(86,33,85));
	}
	return color;
}

public FProperty getSizeColor(RiskLevel riskLevel) {
	FProperty color;
	visit(riskLevel) {
		case \simple(): color = fillColor(rgb(168,219,168));
    	case \moderate(): color = fillColor(rgb(121,189,154));
    	case \high(): color = fillColor(rgb(59,134,134));
    	case \veryhigh(): color = fillColor(rgb(11,72,107));
    	case \tbd(): color = fillColor(rgb(11,72,107));
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

public Figure createComplexityBox(FProperty popup, int complexity, loc src) {
	RiskLevel riskLevel = determineRiskLevelForUnitComplexity(complexity);
	
	FProperty color = getComplexityColor(riskLevel);
	FProperty area = getArea(riskLevel);
	
	return box(area, color, popup, openDocumentOnClick(src));
}

public Figure createUnitSizeBox(FProperty popup, int unitSize, loc src) {
	RiskLevel riskLevel = determineRiskLevelForUnitSize(unitSize);
	
	FProperty color = getSizeColor(riskLevel);
	FProperty area = getArea(riskLevel);
	
	return box(area, color, popup, openDocumentOnClick(src));
}

public Figure createCompilationBox(str state, list[UnitMetric] compilationUnitMetrics) {
	Figures figures = [];
	
	for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {	
		Figure figure;
		FProperty message = popup(name, complexity, size);
		if(state == "Complexity") {
			figure = createComplexityBox(message, complexity, method);	
		} else {
			figure = createUnitSizeBox(message, size, method);	
		}
		figures += figure;
	}
	
	return box(treemap(figures), classColor);
}

private Figure createTreemap(str state, int n, set[CompilationUnitMetric] compilationUnitMetricsSet) {
	Figures figures = [];
	
	for(<loc source, list[UnitMetric] compilationUnitMetrics> <- compilationUnitMetricsSet) {
		fileBox = createCompilationBox(state, compilationUnitMetrics);
		figures += fileBox;
	}

	t = treemap(figures, width(n*3), height(n), resizable(false));
	     
	return t;
}

public Figure drawTreemap(ProjectVisData projectData) {
	// draw treemap panel
	list[str] treeTypes = ["Complexity","Unit size"];
	
	str selectedTreeType = treeTypes[0]; // initial tree type
	str previouslySelectedTreeType; 
	int n = 400;
	int previousN = 0;
	Figure treeMapView = vcat([
							combo(treeTypes, 
									void(str s) {
										// if we change state here, we should be able to access it in computeFigure...
										selectedTreeType = s;
									}, 
									left(),
									resizable(false)),
							vcat([
									scaleSlider(
											int() { return 50; }, 
											int() { return 3000; }, 
											int() { return n; },
											void (int s) { n = s; },
											width(500), left(), top(), resizable(false)),
											
										computeFigure(bool(){
											return (previouslySelectedTreeType != selectedTreeType) || previousN != n;
										},Figure(){
											// redraw complete view with scaleslider each time a user interacts
											previouslySelectedTreeType = selectedTreeType;
											previousN = n;
											return createTreemap(selectedTreeType, n, projectData.analysis.metrics.compilationUnitMetrics);
										})
									])
								], size(1000, 500), left(),top(), resizable(false));
	return treeMapView;
}
