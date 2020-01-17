module visualization::ProjectGraph

import List;
import Relation;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import analysers::LocAnalyser;
import IO;
import vis::Figure; 
import vis::Render;

public Figure renderDependencyGraph(loc p) {
	M3 m = createM3FromEclipseProject(p);

  	classFigures = [box(text("<cl.path[1..]>"), id("<cl>"), fillColor(arbColor())) | cl <- classes(m)]; 
  	
  	edges = [edge("<to>", "<from>") | <from,to> <- m.extends, size(m.declarations[to])>0];  
  	return graph(classFigures, edges, hint("layered"), std(gap(40)), size(500), std(fontSize(10)));
}