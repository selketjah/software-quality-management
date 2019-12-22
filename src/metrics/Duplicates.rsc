module metrics::Duplicates

import IO;
import List;

import collections::Filter;
import cryptograhpy::Hash;
import \lexical::Import;
import metrics::Cache;
import structs::Duplicates;
import string::Trim;

public int findDuplicates(list[str]firstFileContents, list[str] secondFileContents, bool isSameFile){
	DuplicateLocMap pairsFoundMap = getDuplicateDataFromCache();
	
	int count = 0;
	//compute hash for first 6 lines 
	int treshold = 6;
	int fromIndex = 0;
	int toIndex =  fromIndex + treshold-1;
	int occurencesFound = 0;
	
	firstFileContents = trimTerminalChars(removeImports(firstFileContents));
	secondFileContents = trimTerminalChars(removeImports(secondFileContents));
	
	list[str] intersectedPart1 = firstFileContents & secondFileContents;
	list[str] intersectedPart2 = secondFileContents & firstFileContents;
	
	if(size(intersectedPart1) < treshold || size(intersectedPart2)<6){ return 0; }
	
	int sum=0;
	
	while(size(firstFileContents) > toIndex){
		
		//check for duplicate code
		list[str] currentSubjectCode = firstFileContents[fromIndex..toIndex];
		str subjecctForComparisonStr = intercalate(" ",currentSubjectCode);
		real subjectHash = computeHash(subjecctForComparisonStr);
		// if no match is found in the move 1 position
		// if match is found move 6 positions
		occurencesFound = checkForOccurence(subjectHash, secondFileContents, isSameFile, fromIndex, pairsFoundMap);
		
		if(occurencesFound>0) {
			fromIndex += treshold;
			
			
			
			sum= sum+(occurencesFound);
		}
		
		fromIndex+=1;
		toIndex = fromIndex + treshold-1;
	}
	
	//
	//if(size(firstIntersectedPart) > 5 && size(firstIntersectedPart) <= size(secondIntersectedPart)){
	//	count = caculateDuplicates(firstIntersectedPart, secondIntersectedPart, 6);
	//}else if(size(secondIntersectedPart) > 5 && size(secondIntersectedPart) <= size(firstIntersectedPart)){
	//	count = caculateDuplicates(secondIntersectedPart, firstIntersectedPart, 6);
	//}else{
	//	count = 0;
	//}
	//
	//return count;
	
	return sum;
}

public int checkForOccurence(real referenceHash, list[str] fileContents, bool isSameFile, int originalStart, DuplicateLocMap duplicationMap){
	
	int occurencesFound = 0;
	int treshold = 6;
	int fromIndex = 0;
	
	if(isSameFile && fromIndex == originalStart){
		fromIndex +=treshold;
	}
	
	int toIndex =  fromIndex + treshold-1;
	
	while(size(fileContents) > toIndex){
		
		//check for duplicate code
		list[str] currentSubjectCode = fileContents[fromIndex..toIndex];
		str subjecctForComparisonStr = intercalate(" ",currentSubjectCode);
		real subjectHash = computeHash(subjecctForComparisonStr);
		
		if(subjectHash == referenceHash){			
			addToDuplicationMap(duplicationMap,referenceHash, subjecctForComparisonStr);
			
			fromIndex += treshold;
			occurencesFound +=1;
		}else{
			fromIndex += 1;
		}
		
		if(isSameFile && fromIndex == originalStart){
			fromIndex +=treshold;
		}
				
		toIndex = fromIndex + treshold-1;
	}
	
	return occurencesFound;
}

public DuplicateLocMap addToDuplicationMap(DuplicateLocMap duplicationMap, real refHash, str dataString){
	if(refHash in duplicationMap){
		dupLoc = duplicationMap[refHash];
		dupLoc.locations += [|tmp://asd|];
	}else{
		dupLoc = <dataString, [|tmp://as|]>;
		duplicationMap[refHash] = dupLoc;
	}
	return duplicationMap;		
}

public int caculateDuplicates(list[str] targetSubjects, list[str] sourceSubjects, int threshold, int startIndex = 0){
	if(size(targetSubjects) < threshold){return 0;}
	
	DuplicateLocMap pairsFoundMap = getDuplicateDataFromCache();
	int sum = 0;
	int j = startIndex;

	DuplicateCodeLocations dupLoc;
	int maxIndex = size(targetSubjects) - threshold;

	rel[real, str] intersectedPartHashes = {};
	list[real] targetHashes = [];
	
	//get all hashes for all part of size #threshold
	do{
		list[str] subjectsForComparison = [targetSubjects[i] | int i <- [j..(j+threshold)]];
		str subjecctForComparisonStr = intercalate(" ",subjectsForComparison);
		println(subjectsForComparison);
		intersectedPartHashes[computeHash(subjecctForComparisonStr)] = subjecctForComparisonStr;
		
		j = j+threshold;
	}while(j < maxIndex);
		
	
	maxIndex = size(sourceSubjects)-threshold;
	
	//get all hashes for all part of size #threshold
	for(int i <- [startIndex..maxIndex]){
		list[str] subjectsForComparison = [sourceSubjects[i] | int i <- [i..(i + threshold)]];
		targetHashes = targetHashes + computeHash(intercalate(" ",subjectsForComparison));
	}
	
	map[real, int] distributedTargetHash = distribution(targetHashes);
	for(<real hash, str subj> <- intersectedPartHashes){
		if(hash in distributedTargetHash){
			if(hash in pairsFoundMap){
				dupLoc = pairsFound[hash];
				dupLoc.locations += |tmp://asd|;
			}else{
				dupLoc = <subj, [|tmp://as|]>;
				pairsFoundMap[hash] = dupLoc;
			}
			
			sum= sum+(distributedTargetHash[hash]);
		}
	}
	
	println(pairsFoundMap);
	
	return sum;
}