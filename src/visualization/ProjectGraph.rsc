module visualization::ProjectGraph

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
import vis::Render;

public Figure renderDependencyGraph(loc p) {
	M3 m = createM3FromEclipseProject(p);

  	classFigures = [box(text("<cl.path[1..]>"), id("<cl>"), fillColor(arbColor()), onMouseDown(projectGraphClickHandler(min(m.declarations[cl])))) | cl <- classes(m)]; 
  	
  	edges = [edge("<to>", "<from>") | <from,to> <- m.extends, size(m.declarations[to])>0];
  	
  	return graph(classFigures, edges, hint("layered"), std(gap(40)), size(500), std(fontSize(10)));
}

private bool(int, map[KeyModifier, bool]) projectGraphClickHandler(loc src) = bool(int btn, map[KeyModifier, bool] mdf) {
	if(btn == 1){ 
		edit(src);
		return true;
	}
	return false;
};