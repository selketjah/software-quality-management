module visualization::Charts::ProjectGraph

import List;
import Relation;
import Set;
import vis::KeySym;
import Map;
import lang::java::m3::AST;
import util::Math;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Editors;
import analysers::LocAnalyser;
import IO;
import vis::Figure; 
import analysers::M3Analyser;
import scoring::categories::CyclomaticComplexity;
import visualization::Utils;
import vis::Render;
import structs::Visualization;
import structs::RiskLevel;

public Figure renderDependencyGraph(ProjectVisData projectData) {
	// --- just an idea ---
	// create a project graph:
	// - add shadow to abstract types DPME
	// - make items larger or smaller dependening on their level of complexity/LOC FIXED FOR LOC\
	// 
	  	
  	int n = 3;
	int previousN = 0;
	bool addAbstractEffect = false;
	bool addSizeEffect = false;
	bool addComplexityEffect = false;
	
	bool previousAbstractEffectValue = false;
	bool previousSizeEffectValue = false;
	bool previousComplexityEffectValue = false;
	
	Figure graphView = vcat([
						hcat([
							checkbox("Highlight abstract types", void(bool s){ addAbstractEffect = s;}),
							checkbox("LOC indication", void(bool s){ addSizeEffect = s;}),
							checkbox("Complexity indication", void(bool s){ addComplexityEffect = s;})
						], top(), left(), vgap(20)),
						vcat([
							scaleSlider(
									int() { return 1; }, 
									int() { return 20; }, 
									int() { return n; },
									void (int s) { n = s; },
									width(500), resizable(false), vgap(60), left()),
								computeFigure(bool(){
									return previousN != n 
												|| addAbstractEffect 	!= previousAbstractEffectValue 
												|| addSizeEffect 		!= previousSizeEffectValue
												|| addComplexityEffect 	!= previousComplexityEffectValue;
								},Figure(){
									previousN = n;
									previousSizeEffectValue = addSizeEffect;
									previousAbstractEffectValue = addAbstractEffect;
									previousComplexityEffectValue = addComplexityEffect;
									
									return createDependencyGraph(n, projectData, addAbstractEffect, addSizeEffect, addComplexityEffect);						
								})
							], size(1000, 600), resizable(false))]);
	return graphView;
}

public Figure createDependencyGraph(int scale, ProjectVisData projectData, bool hasAbstractShadow, bool hasSizeEffect, bool hasComplexityEffect){
	bool showShadow = false;
	int widthRef = 70;
	int heightRef = 45;

	FProperty boxSize = size(widthRef*scale,heightRef*scale);
	classFigures = [];
	FProperty currentColor;
	str currentShadowColor = "green";
	
	int maxLoc = max(range(projectData.analysis.metrics.locByType.methodHolderSizeRel));
	
	for(<loc name, loc src> <- getMethodHoldingDeclerationsFromM3(projectData.model)){		
		currentColor = fillColor(arbColor());
		
		if(hasAbstractShadow){
			// onderscheid maken tussen abstract vs interface in shadow kleur?
			//terwijl ik dit deed vroeg ik me af of we de interface niet willen tonen?
			Declaration decl = createAstFromFile(src, false);
			if(hasAbstractModifier(decl)){
				showShadow = true;
				currentShadowColor = "green";
			}
		}
		
		if(hasSizeEffect){
			int currentUnitLoc = projectData.analysis.metrics.locByType.methodHolderSizeRel[src];
			real growFactor = 1.00 * currentUnitLoc/maxLoc;
			boxSize = size(widthRef*scale*growFactor, heightRef*scale*growFactor);
		}
		
		if(hasComplexityEffect){
			RiskLevel riskLevel = determineRiskLevelForUnitComplexity(projectData.analysis.metrics.locByType.methodHolderSizeRel[src]);
	
			currentColor = getComplexityColor(riskLevel);
		}
		
		classFigures += box(text("<name.file>"), id("<name>"), boxSize, shadow(showShadow), shadowColor(currentShadowColor), shadowPos(scale*3,scale*2), currentColor, openDocumentOnClick(min(projectData.model.declarations[name])));
		
		showShadow = false;
		
	}
	
  	edges = [edge("<to>", "<from>") | <from,to> <- projectData.model.extends, size(projectData.model.declarations[to])>0];
  	
	return graph(classFigures, edges, hint("layered"), std(gap(scale*4)), std(fontSize(scale*5)), resizable(false));
}

private bool hasAbstractModifier(Declaration decl){
	bool valid  = false;
	visit(decl){
		case \abstract():
			valid = true;
	}
	return valid;
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