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
		list[str] firstFileContents = read(f);
		for(loc f2 <- fLocations){
			if(f2 != f){
				list[str] secondFileContents = read(f2);
				list[str] firstIntersectedPart = firstFileContents & secondFileContents;
				list[str] secondIntersectedPart =  secondFileContents & firstFileContents;
				
				list[str] smallestIntersectedPart = secondIntersectedPart & firstIntersectedPart;
				if(size(smallestIntersectedPart)>5){
					
					if(size(firstFileContents)>5){
						count = calculateNumberOfDuplicates(smallestIntersectedPart, firstFileContents, 6, 0);
						if(count >0){
							println("found #<count> duplicates from <f2> in  <f>");						
							//println("found #<count> duplicates");
						}
					}
					if(size(secondFileContents)>5){
						count = calculateNumberOfDuplicates(smallestIntersectedPart, secondFileContents, 6, 0);
						if(count>0){
											//println(smallestIntersectedPart);
						
							println("found #<count> duplicates from <f> in <f2>");
						}
					}
				}
				
			}
		}
	}
		
	return {};
}

//O(N^2M)
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
	real m = 1e15*9;
	
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