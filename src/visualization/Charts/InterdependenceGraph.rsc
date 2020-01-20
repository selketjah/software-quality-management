module visualization::Charts::InterdependenceGraph

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

public Figure renderInterdependenceGraph(M3 model) {
	lrel [str from, str to] pairs = [ <to.parent.path, from.parent.path> | <from,to> <- model.methodInvocation ];
	nodes = [ellipse(text("<cl>"), id("<cl>"), fillColor(arbColor())) | cl <- pairs];   	
  	edges = [ edge("<to>", "<from>") | <from,to> <- pairs ];
  	
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
									return graph(nodes, edges, hint("layered"), std(gap(5)), size(n), hgap(5), std(fontSize(n*3)), resizable(false));
								})
							]);
	return graphView;
}