module main

import Message;
import Set;
import IO;
import String;
import List;
import Map;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import metrics::Volume;
import util::Resources;
import Relation;
import Set;

public void caculateSIG(loc project){
	int linesOfCode = calculatePhysicalLinesOfCode(project);
	println(linesOfCode);
}


