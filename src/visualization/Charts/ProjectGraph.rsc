module visualization::Charts::ProjectGraph

import List;
import Relation;
import Set;
import vis::KeySym;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Editors;
import analysers::LocAnalyser;
import IO;
import vis::Figure; 
import visualization::Utils;
import vis::Render;

public Figure renderDependencyGraph(M3 model) {

  	classFigures = [box(text("<cl.path[1..]>"), id("<cl>"), fillColor(arbColor()), openDocumentOnClick(min(model.declarations[cl]))) | cl <- classes(model)]; 
  	
  	edges = [edge("<to>", "<from>") | <from,to> <- model.extends, size(model.declarations[to])>0];
  	
  	int n = 10;
	int previousN = 0;
	Figure graphView = vcat([
							scaleSlider(
									int() { return 5; }, 
									int() { return 20; }, 
									int() { return n; },
									void (int s) { n = s; },
									size(500, 50), resizable(false), left(), top()),
								computeFigure(bool(){
									return previousN != n;
								},Figure(){
									previousN = n;
									return graph(classFigures, edges, hint("layered"), std(gap(n*4)), size(n*5), std(fontSize(n)));
								})
							], size(1000, 600), resizable(false));
	return graphView;
}

