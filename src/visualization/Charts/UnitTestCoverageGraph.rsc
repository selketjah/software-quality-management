module visualization::Charts::UnitTestCoverageGraph

import ListRelation;
import List;
import Relation;
import Set;
import  scoring::categories::UnitSize;
import vis::KeySym;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Editors;
import analysers::LocAnalyser;
import structs::Visualization;
import IO;
import vis::Figure; 
import visualization::Utils;
import structs::UnitTestCoverage;
import structs::Volume;
import vis::Render;

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

public Figure renderUnitTestCoverageGraph(ProjectVisData projectData) {
		
	//start off by visualising what methods are called in different test methods
	// draw treemap panel
	list[str] treeTypes = ["Complexity","Unit size"];
	
	str selectedTreeType = treeTypes[0]; // initial tree type
	str previouslySelectedTreeType; 
	int n = 400;
	int previousN = 0;
	Figure treeMapView = vcat([
							//combo(treeTypes, 
							//		void(str s) {
							//			// if we change state here, we should be able to access it in computeFigure...
							//			selectedTreeType = s;
							//		}, 
							//		center(), 
							//		resizable(false)),
							vcat([
									scaleSlider(
											int() { return 50; }, 
											int() { return 3000; }, 
											int() { return n; },
											void (int s) { n = s; },
											width(600), center(), top(), gap(10), vgap(40), resizable(false)),
											
										computeFigure(bool(){
											return (previouslySelectedTreeType != selectedTreeType) || previousN != n;
										},Figure(){
											// redraw complete view with scaleslider each time a user interacts
											previouslySelectedTreeType = selectedTreeType;
											previousN = n;
											
											return createTreemap(selectedTreeType, n, projectData.analysis.unitTestCoverageMap, projectData.analysis.methods, projectData.analysis.metrics.locByType.methodSizeRel, projectData.model);
										})
									])
								], center(),top());
	return treeMapView;
}


private Figure createTreemap(str state, int n, UnitTestCoverageMap unitTestCoverageMap, rel[loc name,loc src] methodLocRels, ComponentLOC methodSizeRel, M3 model) {
    Figures figures = [];
	int i = 0;
	
	int totalUnitTestCoverageLoc = (0 | it + unitTestCoverageMap[src].locCoverage | loc src <-unitTestCoverageMap);
	int coverageSum=0;
	for(loc src <- unitTestCoverageMap) {
		UnitTestCoverage coverageMap = unitTestCoverageMap[src];

		coverageSum += methodSizeRel[src];
		RiskLevel currentUnitTestRiskLevel = determineRiskLevelForUnitSize(methodSizeRel[src]);
		figures+=box(
					box(
						vcat([						
							createTreemap(src, coverageMap.methodCalls, methodLocRels, methodSizeRel, model)
						]), shrink(0.8)
					),
					getArea(currentUnitTestRiskLevel), 
					getSizeColor(currentUnitTestRiskLevel));
	}
	
	t = treemap(figures, width(n), height(n),resizable(false));
	     
	return t;
}

private Figure createTreemap(loc parentRef, list[loc] methodCalls, rel[loc name, loc src] methodLocRels, ComponentLOC methodSizeRel, M3 model){
	rel[loc src, loc name] invertedDeclarations = invert(model.declarations);
	if(size(methodCalls)>0){
		return treemap([ box(getArea(determineRiskLevelForUnitSize(methodSizeRel[mth])), getInnerSizeColor(determineRiskLevelForUnitSize(methodSizeRel[mth])), popup(min(invertedDeclarations[mth]).path[1..]), openDocumentOnClick(mth)) | loc mth <- methodCalls]);
	}else{
		return ellipse(fillColor("red"));
	}
}

public FProperty getInnerSizeColor(RiskLevel riskLevel) {
	FProperty color;
	visit(riskLevel) {
		case \simple(): color = fillColor(rgb(194,201, 169));
    	case \moderate(): color = fillColor(rgb(140,163,142));
    	case \high(): color = fillColor(rgb(87,124,114));
    	case \veryhigh(): color = fillColor(rgb(33,85,86));
    	case \tbd(): color = fillColor(rgb(33,85,86));
	}
	return color;
}

public FProperty getSizeColor(RiskLevel riskLevel) {
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

FProperty simpleBoundArea = area(5);
FProperty moderateBoundArea = area(10);
FProperty highBoundArea = area(15);
FProperty veryHighBoundArea = area(20);

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