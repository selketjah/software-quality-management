module visualization::Charts::InterdependenceGraph
import analysers::M3Analyser;
import IO;
import List;
import Relation;
import Set;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Editors;
import analysers::LocAnalyser;


import vis::Figure; 
import vis::KeySym;
import vis::Render;

import visualization::Utils;

import String;
import IO;
public Figure renderInterdependenceGraph(M3 model) {
	rel[loc name, loc src] methods = getMethodsFromM3(model);
	
	list[loc] allFromCanContainMethods = [name| <loc name, loc src> <- getMethodHoldingDeclerationsFromM3(model)];
															
	nodes = [ ellipse(text(src.file), id("<src>"), fillColor(arbColor())) | loc src <- allFromCanContainMethods ];
	
	edges = [];
	
	for(loc src <- allFromCanContainMethods){
		if(!isEmpty(model.containment[src])){
			for(loc to <- model.typeDependency[src]){
				if(!isEmpty(model.containment[to])){
					edges +=edge("<src>", "<to>");
				}
			}	
		}
	}
	
	int n = 5;
	int previousN = 0; 
	Figure graphView = vcat([
							scaleSlider(
									int() { return 0; }, 
									int() { return 20; }, 
									int() { return n; },
									void (int s) { n = s; },
									width(500), resizable(false), left()),
								computeFigure(bool(){
									return previousN != n;
								},Figure(){
									previousN = n;
									return graph(nodes, edges, hint("layered"), std(gap(5)), size(n), hgap(5), std(fontSize(n*3)));
								})
							]);
	
	
	return graphView;
}