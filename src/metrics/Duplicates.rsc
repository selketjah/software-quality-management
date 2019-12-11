module metrics::Duplicates

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import metrics::Volume;

public set[loc] detectClones(list[loc] fileLocations){
	
	// take 2 locations and check detection
	CompilationUnitLoc compLoc = calculateUnitSize(|project://Jabberpoint-le3/src/SlideViewerFrame.java|);
	println(compLoc.componentUnitLocCollection[1]);
	println(compLoc.componentUnitLocCollection[2]);
	
	
	
	return {};
}