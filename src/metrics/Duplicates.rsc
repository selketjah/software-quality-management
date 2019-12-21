module metrics::Duplicates

import IO;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import metrics::Volume;
import String;
import util::Math;
import metrics::Cache;

lexical TerminalBrackets = "{"?![\n]*"}"? $;
syntax TerminalBracketsSyntax
  = TerminalBrackets;

alias DuplicatePairs = map[loc,tuple[int size, list[str] duplicateSrc]];


public set[loc] detectClones(list[ComponentLOC] methodComponentRefs){
 	
	// take 2 locations and check detection
	// the compilationunit is needed in order to gain acces to individual raw method loc 
	CompilationUnitLoc compLoc = calculateUnitSize(|project://Jabberpoint-le3/src/SlideViewerFrame.java|);
	
	// O(N)
	list[loc] fLocations = [ cu.src | ComponentLOC cu <- methodComponentRefs];
	
	println(compLoc.componentUnitLocCollection[1].src);
	println(compLoc.componentUnitLocCollection[2].src);
	int count = 0;
	for(loc f <- fLocations){
		count = 0;
		list[str] firstFileContents = read(f);
		for(loc f2 <- fLocations){
			if(f2 != f){
				list[str] secondFileContents = read(f2);
				list[str] firstIntersectedPart = firstFileContents & secondFileContents;
				list[str] secondIntersectedPart =  secondFileContents & firstFileContents;
				
				if(size(firstIntersectedPart) > 5 && size(firstIntersectedPart) < size(secondIntersectedPart) && !hasMoreSpecialCharThanOthers(firstIntersectedPart)){
					count = calculateNumberOfDuplicates(firstIntersectedPart, secondIntersectedPart, 6, 0);
				}else{
					count = 0;
				}
				
				if(count == 1 && f2.path == f.path){
					count=0;
				}
				
				if(count>0){
					// further testing is needed....
					println("duplicates found in <f> && <f2> #<count>");
				}					
			}
		}
	}
	
	return {};
}

public int calculateNumberOfDuplicates(list[str] targetSubjects, list[str] sourceSubjects, int threshold, int startIndex){
	if(size(targetSubjects) < threshold){return 0;}
	
	
	//get all hashes for all part of size #threshold
	int maxIndex = size(targetSubjects)-threshold;
	list[real] intersectedPartHashes = [];
	real intersectedPartHash = computeHash(intercalate(" ",targetSubjects));
	
	int j = 0;
	do{
		list[str] subjectsForComparison = [targetSubjects[i] | int i <- [j..(j+threshold)]];
		intersectedPartHashes = intersectedPartHashes + computeHash(intercalate(" ",subjectsForComparison));
		
		j = j+threshold;
	}while(j < maxIndex);
		
	list[real] targetHashes = [];
	maxIndex = size(sourceSubjects)-threshold;
	
	//get all hashes for all part of size #threshold
	for(int i <- [startIndex..maxIndex]){
		list[str] subjectsForComparison = [sourceSubjects[i] | int i <- [i..(i+threshold)]];
		targetHashes = targetHashes + computeHash(intercalate(" ",subjectsForComparison));
	}
	
	map[real, int] distributedTargetHash= distribution(targetHashes);
	int sum = 0;
	for(real hash <- intersectedPartHashes){
		if(hash in distributedTargetHash){
			sum= sum+(distributedTargetHash[hash]);
		}
	}
	
	return sum;
}

public real computeHash(str toBeHashed){
	real p = 35.0;
	real m = 1e52*33;
	
	real hashVal = 0.0;
	real pPow= 1.0;
	setPrecision(0);
	for(int c <- chars(toBeHashed)){
		hashVal = toReal(modulo((hashVal + toReal(c - chars("a")[0] + 1) * pPow), m));

		pPow = toReal(modulo((pPow * p),m));
	}
	
	return hashVal;
}

public int modulo(real a, real b){
	
	return toInt(a - b * toInt(a/b));
}

public bool hasMoreSpecialCharThanOthers(list[str] subjectList){
	int numberOfTerminals = size([subject |str subject <- subjectList, subject == "}" || subject =="{" || subject == "});"]);
	
	return ((size(subjectList)-numberOfTerminals) < (size(subjectList)/2));
}