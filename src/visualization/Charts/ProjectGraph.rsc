module visualization::Charts::ProjectGraph

import List;
import Relation;
import Set;
import vis::KeySym;
import Map;
import lang::java::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Editors;
import analysers::LocAnalyser;
import IO;
import vis::Figure; 
import visualization::Utils;
import vis::Render;
import structs::Visualization;

public Figure renderDependencyGraph(ProjectData projectData) {
	// --- just an idea ---
	// create a project graph:
	// - add shadow to abstract types DPME
	// - make items larger or smaller dependening on their level of complexity/LOC FIXED FOR LOC\
	// 
	  	
  	int n = 3;
	int previousN = 0;
	bool addAbstractEffect = false;
	bool addSizeEffect = false;
	bool previousAbstractEffectValue = false;
	bool previousSizeEffectValue = false;
	
	Figure graphView = hcat([
						vcat([
							checkbox("Highlight abstract types", void(bool s){ addAbstractEffect = s;}),
							checkbox("LOC indication", void(bool s){ addSizeEffect = s;})
						], top(), vgap(20)),
						vcat([
							scaleSlider(
									int() { return 1; }, 
									int() { return 20; }, 
									int() { return n; },
									void (int s) { n = s; },
									width(500), resizable(false), vgap(60), left()),
								computeFigure(bool(){
									return previousN != n 
												|| addAbstractEffect != previousAbstractEffectValue 
												|| previousSizeEffectValue != addSizeEffect;
								},Figure(){
									previousN = n;
									previousSizeEffectValue = addSizeEffect;
									previousAbstractEffectValue = addAbstractEffect;
									return createDependencyGraph(n, projectData, addAbstractEffect, addSizeEffect);						
								})
							], size(1000, 600), resizable(false))]);
	return graphView;
}

public Figure createDependencyGraph(int scale, ProjectData projectData, bool hasAbstractShadow, bool hasSizeEffect){
	bool showShadow = false;
	FProperty boxSize = size(16*scale,8*scale);
	FProperty growFactory =grow(1);
	classFigures = [];
	
	int maxLoc = max(range(projectData.metrics.locByType.methodHolderSizeRel));
	
	for(cl <- classes(projectData.model)){
		if(size(projectData.model.declarations[cl])==0){ continue; }
		loc currentFileLoc = toList(projectData.model.declarations[cl])[0];
		if(hasAbstractShadow){
			// onderscheid maken tussen abstract vs interface in shadow kleur?
			showShadow = isAbstractType(currentFileLoc);
		}
		
		if(hasSizeEffect){
			int currentUnitLoc = projectData.metrics.locByType.methodHolderSizeRel[currentFileLoc];
			growFactory = grow((0.00 + currentUnitLoc)/maxLoc);
		}
	
		classFigures += box(text("<cl.path[1..]>"), growFactory, id("<cl>"), boxSize, shadow(showShadow), shadowPos(scale*1,scale*1), fillColor(arbColor()), openDocumentOnClick(min(projectData.model.declarations[cl])));
		
		showShadow = false;
		growFactory = grow(1);
	}
	
  	edges = [edge("<to>", "<from>") | <from,to> <- projectData.model.extends, size(projectData.model.declarations[to])>0];
  	
	return graph(classFigures, edges, hint("layered"), std(gap(scale*4)), size(scale*5), std(fontSize(scale*5)));
}

private bool isAbstractType(loc src){
	bool valid = false;
	Declaration decl = createAstFromFile(src, false);
	visit(decl){
		case \abstract():
			valid = true;
		
		case \interface(_, _, _, _):
		 	valid = true;
	}
	return valid;
}
