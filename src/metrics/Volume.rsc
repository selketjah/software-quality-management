module metrics::Volume

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
import util::Resources;
import analysers::LocAnalyser;
import Relation;
import Set;
import metrics::UnitTestCoverage;
import metrics::Cache;

alias CompilationUnitLoc = tuple[ComponentLOC compilationUnit, set[ComponentLOC] strucUnitLoc, list[ComponentLOC] componentUnitLocCollection];
alias ComponentLOC = tuple[loc src, int size];
alias CommentLocation = tuple[int offset, int length];

public set[CompilationUnitLoc] calculatePhysicalLinesOfCode(list[loc] fileLocations){
	
	set[CompilationUnitLoc] projectCULocCollection = { calculateUnitSize(fileLoc) | loc fileLoc <- fileLocations};
	
	return projectCULocCollection;
}

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
	M3 fileM3Model = createM3FromFile(source);
	set[loc] commentLocations = range(fileM3Model.documentation);
	
	lrel[int offset, int length] commentLocationMap=[ <commentLoc.offset, commentLoc.length> | loc commentLoc <-commentLocations];
	commentLocationMap = sort(commentLocationMap, locationSortFunction);
	str subject = readFile(source);
	
	int correctedOffset = 0;
	
	for(CommentLocation commentLocation <- commentLocationMap){
		str before = substring(subject, 0, commentLocation.offset - correctedOffset);
		str after =  substring(subject, commentLocation.offset - correctedOffset + commentLocation.length);
		
		subject = before + after;
		correctedOffset = correctedOffset + commentLocation.length;
	}
	
	list[str] linesOfCode = ([trim(line) | str line <- split("\n", subject), size(trim(line)) > 0 ]);
	store(source, linesOfCode);
	return <source, size(linesOfCode)>;
}


bool locationSortFunction(CommentLocation locA, CommentLocation locB){
	return locA.offset < locB.offset;
}

public list[loc] listFiles(Resource currentProjectResource) {
	return [ a | /file(a) <- currentProjectResource, isJavaFile(a) ];
}

public set[loc] listMethods(Resource currentProjectResource) {
	return { a | /file(a) <- currentProjectResource, isJavaFile(a) && isMethod(a) };
}