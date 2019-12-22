module metrics::Duplicates

import IO;
import List;

import collections::Filter;
import cryptograhpy::Hash;
import \lexical::Import;
import metrics::Cache;
import structs::Duplicates;
import string::Trim;

public int findDuplicates(list[str]firstFileContents, list[str] secondFileContents){
	
	int count = 0;
	firstFileContents = trimTerminalChars(removeImports(firstFileContents));
	secondFileContents = trimTerminalChars(removeImports(secondFileContents));
	
	// shouldn't intersect!
	list[str] firstIntersectedPart = firstFileContents & secondFileContents;
	list[str] secondIntersectedPart =  secondFileContents & firstFileContents;
	
	if(size(firstIntersectedPart) > 5 && size(firstIntersectedPart) <= size(secondIntersectedPart)){
		count = caculateDuplicates(firstIntersectedPart, secondIntersectedPart, 6);
	}else if(size(secondIntersectedPart) > 5 && size(secondIntersectedPart) <= size(firstIntersectedPart)){
		count = caculateDuplicates(secondIntersectedPart, firstIntersectedPart, 6);
	}else{
		count = 0;
	}
	
	return count;
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