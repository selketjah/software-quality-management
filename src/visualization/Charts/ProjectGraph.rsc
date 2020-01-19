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

public Figure renderDependencyGraph(loc p) {
	M3 m = createM3FromEclipseProject(p);

  	classFigures = [box(text("<cl.path[1..]>"), id("<cl>"), fillColor(arbColor()), openDocumentOnClick(min(m.declarations[cl]))) | cl <- classes(m)]; 
  	
  	edges = [edge("<to>", "<from>") | <from,to> <- m.extends, size(m.declarations[to])>0];
  	
  	int n = 10;
	int previousN = 0;
	Figure graphView = vcat([
							scaleSlider(
									int() { return 5; }, 
									int() { return 20; }, 
									int() { return n; },
									void (int s) { n = s; },
									width(500), resizable(false), left()),
								computeFigure(bool(){
									return previousN != n;
								},Figure(){
									previousN = n;
									return graph(classFigures, edges, hint("layered"), std(gap(n*4)), size(n*5), std(fontSize(n)));
								})
							], resizable(false));
	return graphView;
}

