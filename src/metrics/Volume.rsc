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

public CompilationUnitLoc calculateUnitSize(loc file){
	M3 fileM3Model = createM3FromFile(file);
	ComponentLOC compilationUnitLoc;
	set[ComponentLOC] strucUnitLoc={};
	list[ComponentLOC] componentUnitLocCollection=[];
	
	rel[loc name,loc src] decls = fileM3Model.declarations;
	int assertCount ;
	for(<loc name, loc src> <- decls){
		if(isCompilationUnit(name)){
			compilationUnitLoc = calculateLinesOfCode(src);
		}

		if(canContainMethods(name)){
			strucUnitLoc += calculateLinesOfCode(src);
		}
		
		if(isMethod(name)) {
			
			ComponentLOC currentLoc = calculateLinesOfCode(src);
			currentLoc.size =currentLoc.size-2; 
			componentUnitLocCollection +=currentLoc;
		}
	}
	
	return <compilationUnitLoc, strucUnitLoc, componentUnitLocCollection>;
}

public ComponentLOC calculateLinesOfCode(loc source) {
	list[str] linesOfCode;
	
	str subject = getCompilationUnitAsStringWithoutComments(source);
	
	linesOfCode = stringToTrimmedList(subject);
	return <source, size(linesOfCode)>;
}

public str getCompilationUnitAsStringWithoutComments(loc source){
	int correctedOffset = 0;
	M3 fileM3Model = createM3FromFile(source);
	set[loc] commentLocations = range(fileM3Model.documentation);
	lrel[int offset, int length] commentLocationMap= [<commentLoc.offset, commentLoc.length> | loc commentLoc <-commentLocations];
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