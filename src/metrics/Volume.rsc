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
import Relation;
import Set;

alias CommentLocation = tuple[int offset, int length];

//	LOC is any line of program text that is not a comment and blank lines, regardless of number of statements on the line
//	includes all lines containing program headers, declarations & executable and non executable statements
public int calculatePhysicalLinesOfCode(loc project){
	Resource currentProjectResource = getProject(project);

	set[loc] fileLocations = listFiles(currentProjectResource);
	
	rel[loc,int] fileSizeMap = {calculateFileSize(fileLoc) | loc fileLoc <- fileLocations};
	
	return sum(range(fileSizeMap));
}

public tuple[loc offset, int size] calculateFileSize(loc file) {
	// create m3 model for file
	M3 fileM3Model = createM3FromFile(file);
	
	set[loc] commentLocations = range(fileM3Model.documentation);
	
	lrel[int offset, int length] commentLocationMap=[ <commentLoc.offset, commentLoc.length> | loc commentLoc <-commentLocations];
	commentLocationMap = sort(commentLocationMap, locationSortFunction);
	str subject = readFile(file);
	
	int correctedOffset = 0;
	for(CommentLocation commentLocation <- commentLocationMap){
		str before = substring(subject, 0, commentLocation.offset- correctedOffset);
		str after =  substring(subject, commentLocation.offset -correctedOffset + commentLocation.length);
		
		subject = before + after;
		correctedOffset = correctedOffset + commentLocation.length;
	}
	
	list[str] linesOfCode = ([trim(line) | str line <- split("\n", subject), size(trim(line)) > 0 ]);
	return <file, size(linesOfCode)>;
}

bool locationSortFunction(CommentLocation locA, CommentLocation locB){
	return locA.offset < locB.offset;
}

public set[loc] listFiles(Resource currentProjectResource) {
	return { a | /file(a) <- currentProjectResource, a.extension == "java" };
}