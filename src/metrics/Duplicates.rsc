module metrics::Duplicates

import IO;
import List;

import collections::Filter;
import cryptograhpy::Hash;
import \lexical::Import;

alias DuplicatePairs = map[loc,tuple[int size, list[str] duplicateSrc]];

public int findDuplicates(list[str]firstFileContents, list[str] secondFileContents){	
	int count =0;
	firstFileContents = removeImports(firstFileContents);
	secondFileContents = removeImports(secondFileContents);
	
	list[str] firstIntersectedPart = firstFileContents & secondFileContents;
	list[str] secondIntersectedPart =  secondFileContents & firstFileContents;
	
	if(size(firstIntersectedPart) > 5 && size(firstIntersectedPart) < size(secondIntersectedPart) && 
			!hasMoreSpecialCharThanOthers(firstIntersectedPart)){
		count = calculateNumberOfDuplicates(firstIntersectedPart, secondIntersectedPart, 6, 0);
	}else if(size(secondIntersectedPart) > 5 && size(secondIntersectedPart) < size(firstIntersectedPart) && 
			!hasMoreSpecialCharThanOthers(secondIntersectedPart)){
		count = calculateNumberOfDuplicates(secondIntersectedPart, firstIntersectedPart, 6, 0);
	}else{
		count = 0;
	}
	
	return count;
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

public bool hasMoreSpecialCharThanOthers(list[str] subjectList){
	int numberOfTerminals = size([subject |str subject <- subjectList, subject == "}" || subject =="{" || subject == "});"]);
	
	return ((size(subjectList)-numberOfTerminals) < (size(subjectList)/2));
}