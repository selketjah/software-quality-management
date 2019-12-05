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

// Common methods of size estimation:
//- LOC:
//	any line of programming that is not a comment or a blank regardless of number of statements on the line
//	LOC is any line of program text that is not a comment and blank lines, regardless of number of statements on the line
//	includes all lines containing program headers, declarations & executable and non executable statements
//	- advantages: 
//		- size estimation
//		- easy to count and calculate from dev code
//				
//	- disadvantage: 
//		- LOC is lang & tech dependent
//		-	Bad soft design may cause excessive LOC

int calculatePhysicalLinesOfCode(loc project){
	M3 model = createM3FromEclipseProject(project);
	rel[loc definition, loc comments] docOverview = model.documentation;
	map[loc, [str]] fileSet=();
	
	set[loc] fileLocationSet = { project+comments.path | <loc def, loc comments> <- docOverview};
	map[loc, str] fileLocationTextMap = ( fileLoc : readFile(fileLoc) |loc fileLoc <- fileLocationSet);
	map[loc, lrel[int offset,int length]] fileLocationCommentArrayMap = (fileLocation:getComments(docOverview, fileLocation, project)|loc fileLocation<-fileLocationSet);
	rel[loc,int] fileLocationSizeMap = {};
	
	for(loc f <- fileLocationSet){
		str contentWithoutComments = removeComments(fileLocationCommentArrayMap[f], fileLocationTextMap[f]);
		
		list[str] lines = [trim(line)  | line <- split("\n", contentWithoutComments), size(trim(line))>0];
		
		fileLocationSizeMap+=<f,size(lines)>;
	}
	
	list[int] sizeList = [toList(currentSet)[0] | set[int] currentSet <- groupRangeByDomain(fileLocationSizeMap)];
	return sum(sizeList);
}

str removeComments(lrel[int offset,int length] commentsRel, str content){
	
	for(<int offset, int length> <- commentsRel){
		str partInFile = substring(content,offset,offset+length);
		content = replaceAll(content,partInFile, intercalate("", [" "| x<-[0..length]]));
	}
	return content;
}

lrel[int,int] getComments(rel[loc, loc] documentationOverview, loc fileLocation, loc project){
	return [<comments.offset,comments.length> | <loc def, loc comments> <- documentationOverview, fileLocation == project+comments.path];
}