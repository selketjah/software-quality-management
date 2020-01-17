module metrics::Volume

import IO;
import lang::java::m3::Core;
import List;
import Relation;
import Set;
import String;
import util::Resources;

import analysers::LocAnalyser;
import collections::Sort;
import resource::IO;
import string::Trim;

alias ComponentLOC = map[loc src, int size];

public map[loc src, list[str] linesOfCode]  getLinesOfCode2(rel[loc name,loc src] compilationUnits, rel[loc name,loc src] methodHolders, rel[loc name,loc src] methods){
	return (src:srcToLoc(src) | <loc name, loc src> <- compilationUnits)
	 		+ (src:srcToLoc(src) | <loc name, loc src> <- methodHolders)
	 		+ (src:srcToLoc(src) | <loc name, loc src> <- methods);
}

public ComponentLOC calculateLinesOfCode(rel[loc name,loc src] unitRelation, map[loc src, list[str] linesOfCode]  compilationUnitMap){
	return ( src:calculateLinesOfCode(src, compilationUnitMap[src]) | <loc name, loc src> <- unitRelation);
}

public int calculateLinesOfCode(loc src, list[str] linesOfCode) {
	return size(linesOfCode);
}

public int calculateUnitVolume(loc src){
	return size(srcToLoc(src))-2;
}

public  list[str] srcToLoc(loc source){
	str subject = getCompilationUnitAsStringWithoutComments(source);
	return stringToTrimmedList(subject);
}

public ComponentLOC calculateLinesOfCode(loc src, list[str] linesOfCode) {
	return <src, size(linesOfCode)>;
}

public str getCompilationUnitAsStringWithoutComments(loc source){
	int correctedOffset = 0;
	M3 fileM3Model = createM3FromFile(source);
	set[loc] commentLocations = range(fileM3Model.documentation);
	lrel[int offset, int length] commentLocationMap = [<commentLoc.offset, commentLoc.length> | loc commentLoc <-commentLocations];
	str subject = readFile(source);
	
	commentLocationMap = sort(commentLocationMap, locationSortFunction);
	
	for(CommentLocation commentLocation <- commentLocationMap){
		str before = substring(subject, 0, commentLocation.offset - correctedOffset);
		str after =  substring(subject, commentLocation.offset - correctedOffset + commentLocation.length);
		
		subject = before + after;
		correctedOffset = correctedOffset + commentLocation.length;
	}
	
	return subject;
}

// for a particular test method:
// count all lines of code that are linked to the given asserts (method invocations)
public int calculateInvokedLinesOfCode(loc src, ComponentLOC methodSizeMap, M3 model){
	int size =0;
	for(loc methodInvocationLocation <- model.methodInvocation[src]){
		//get method location
		set[loc] methodLocationSet = model.declarations[methodInvocationLocation];
		
		if(!isEmpty(methodLocationSet)){
			loc methodLocation = min(methodLocationSet);
			
			if(methodLocation in methodSizeMap){
				size += methodSizeMap[methodLocation];
			}
		}
	}
	
	return size;
}