module visualization::Charts::DuplicationGraph

import ListRelation;
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

public Figure renderDuplicationGraph(rel[loc, loc] duplicationRelationships) {

	nodes = [ellipse(text("<cl.file>"), id("<cl>"), fillColor(arbColor()), openDocumentOnClick(cl)) | cl <- carrier(duplicationRelationships)]; 
  	
  	edges = [ edge("<to>", "<from>") | <from,to> <- duplicationRelationships ];
	
	int n = 5;
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
									return graph(nodes, edges, hint("layered"), std(gap(5)), size(n), hgap(2), std(fontSize(n*3)));
								})
							], size(1000, 600), resizable(false));
	return graphView;
}