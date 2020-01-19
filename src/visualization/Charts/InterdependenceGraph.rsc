module visualization::Charts::InterdependenceGraph

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

public Figure renderInterdependenceGraph(loc p) {
	M3 m = createM3FromEclipseProject(p);
  	
  	return box();
}