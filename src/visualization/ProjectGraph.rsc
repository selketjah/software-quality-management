dmodule visualization::ProjectGraph

import List;
import Relation;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import IO;
import vis::Figure; 
import vis::Render;

public void drawDiagram(loc p) {
	M3 m = createM3FromEclipseProject(p);

  	classFigures = [box(text("<cl.path[1..]>"), id("<cl>")) | cl <- classes(m)]; 
  	edges = [edge("<to>", "<from>") | <from,to> <- m.extends ];  
  
  	render(graph(classFigures, edges, hint("layered"), std(gap(10)), std(font("Bitstream Vera Sans")), std(fontSize(20))));
}