module visualization::Charts::Treemapping

import IO;

import metrics::UnitMetrics;

import scoring::categories::CyclomaticComplexity;
import scoring::categories::UnitSize;
import structs::RiskLevel;
import structs::UnitMetrics;

import structs::Visualization;
import visualization::Visualization;

import vis::Figure;
import vis::Render;

FProperty classColor = fillColor(rgb(197,247,240));
FProperty classArea = area(40);

FProperty simpleBoundArea = area(3);
FProperty moderateBoundArea = area(7);
FProperty highBoundArea = area(11);
FProperty veryHighBoundArea = area(15);

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

public Figure createComplexityBox(int complexity) {
	RiskLevel riskLevel = determineRiskLevelForUnitComplexity(complexity);
	
	FProperty color = getComplexityColor(riskLevel);
	FProperty area = getArea(riskLevel);
	
	return box(area, color);
}

public Figure createUnitSizeBox(int unitSize) {
	RiskLevel riskLevel = determineRiskLevelForUnitSize(unitSize);
	
	FProperty color = getSizeColor(riskLevel);
	FProperty area = getArea(riskLevel);
	
	return box(area, color);
}

public Figure createCompilationBox(str state, list[UnitMetric] compilationUnitMetrics) {
	Figures figures = [];
	
	for(<str name, loc method, int complexity, int size> <- compilationUnitMetrics) {
		Figure figure = createComplexityBox(complexity);
		if(state == "Complexity") {
			figure = createComplexityBox(complexity);	
		} else {
			figure = createUnitSizeBox(size);	
		}
		figures += figure;
	}
	
	return box(treemap(figures) ,shrink(0.9), classArea, classColor);
}

private Figure createTreemap(str state, set[CompilationUnitMetric] compilationUnitMetricsSet) {
	Figures figures = [];
	
	for(<loc source, list[UnitMetric] compilationUnitMetrics> <- compilationUnitMetricsSet) {
		fileBox = createCompilationBox(state, compilationUnitMetrics);
		figures += fileBox;
	}

	t = treemap(figures);
	     
	return t;
}

public Figure drawTreemap(map[str, Figure] state, ProjectData projectData) {
	Figure treemap = state["heatmap"] ? createTreemap("Complexity", projectData.metrics.compilationUnitMetrics);
	
  	return vcat([ combo(["Complexity","Unit size"], void(str s) { state["heatmap"] = createTreemap(s, projectData.metrics.compilationUnitMetrics);
  																  renderVisualization(\heatmap(), projectData, state); }, resizable(false)),
  			      treemap               
              ]);
}

