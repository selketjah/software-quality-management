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

alias CompilationUnitLoc = tuple[ComponentLOC compilationUnit, set[ComponentLOC] strucUnitLoc, list[ComponentLOC] componentUnitLocCollection];
alias ComponentLOC = tuple[loc src, int size];

public ComponentLOC calculateLinesOfCode(loc src, list[str] linesOfCode) {
	return <src, size(linesOfCode)>;
}

public int calculateUnitVolume(loc src){
	return size(srcToLoc(src))-2;
}

public list[str] srcToLoc(loc source){
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