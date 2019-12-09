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

alias CommentLocation = tuple[int offset, int length];

public int calculatePhysicalLinesOfCode(loc project){
	Resource currentProjectResource = getProject(project);

	set[loc] fileLocations = listFiles(currentProjectResource);
	
	rel[loc,int] fileSizeMap = {calculateLinesOfCode(fileLoc) | loc fileLoc <- fileLocations};
	
	return sum(range(fileSizeMap));
}

public tuple[loc src, int size] calculateLinesOfCode(loc source) {
	M3 fileM3Model = createM3FromFile(source);
	set[loc] commentLocations = range(fileM3Model.documentation);
	
	lrel[int offset, int length] commentLocationMap=[ <commentLoc.offset, commentLoc.length> | loc commentLoc <-commentLocations];
	commentLocationMap = sort(commentLocationMap, locationSortFunction);
	str subject = readFile(source);
	
	int correctedOffset = 0;
	for(CommentLocation commentLocation <- commentLocationMap){
		str before = substring(subject, 0, commentLocation.offset- correctedOffset);
		str after =  substring(subject, commentLocation.offset -correctedOffset + commentLocation.length);
		
		subject = before + after;
		correctedOffset = correctedOffset + commentLocation.length;
	}
	
	list[str] linesOfCode = ([trim(line) | str line <- split("\n", subject), size(trim(line)) > 0 ]);
	return <source, size(linesOfCode)>;
}

bool locationSortFunction(CommentLocation locA, CommentLocation locB){
	return locA.offset < locB.offset;
}

public set[loc] listFiles(Resource currentProjectResource) {
	return { a | /file(a) <- currentProjectResource, isJavaFile(a) };
}

public set[loc] listMethods(Resource currentProjectResource) {
	return { a | /file(a) <- currentProjectResource, isJavaFile(a) && isMethod(a) };
}