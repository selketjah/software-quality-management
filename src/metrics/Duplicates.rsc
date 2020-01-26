module metrics::Duplicates

import IO;
import List;
import Set;
import util::Math;
import String;
import List;
import Relation;
import Map;

import collections::Filter;
import cryptograhpy::Hash;
import \lexical::Import;
import metrics::Cache;
import metrics::Volume;
import metrics::UnitMetrics;
import string::Trim;
import structs::Duplication;

public DuplicationData calculateDuplicates(rel[loc name,loc src] methodHolders, map[loc src, list[str] linesOfCode] compilationUnitMap){
	DuplicateCodeRel duplicationRel = {};
	list[loc] methodHolderDup = toList(range(methodHolders));
	rel[loc, loc] duplicateionMapRel = {};
	
	for(loc src <- toList(range(methodHolders))){
		for(loc src2 <- methodHolderDup){
			DuplicateCodeRel codeRel = listClonesIn(src, compilationUnitMap[src], src2, compilationUnitMap[src2]);
			
			if(size(union(range(codeRel)))>0){
				duplicateionMapRel += <src,src2>;
			}
			
			duplicationRel += codeRel;
		}
		methodHolderDup = delete(methodHolderDup,indexOf(methodHolderDup, src));
	}
	
	return <duplicationRel, duplicateionMapRel>;
}


public DuplicateCodeRel listClonesIn(loc firstSrc, list[str] firstFileContents, loc secondSrc, list[str] secondFileContents, int treshold = 6){
	DuplicateCodeRel resultMap={};
	bool isSameFile = firstSrc == secondSrc;	
	set[str] fileContentsIntersectionSet;
	list[str] fileContentsIntersectionList = getIntersectionBetween(firstFileContents, secondFileContents, isSameFile);	
	
	if(size(fileContentsIntersectionList) < treshold){
		return {}; // return empty list if there aren't enough common LOC present 
	}
	
	fileContentsIntersectionSet = toSet(fileContentsIntersectionList);
	
	set[list[int]] firstFileDuplicateEntrySet = mapDuplicates(firstFileContents, fileContentsIntersectionSet, isSameFile);
	
	firstFileDuplicateEntrySet = filterSequencesByThreshold(firstFileDuplicateEntrySet, firstFileContents, treshold);

	resultMap = createResultMap(firstSrc, firstFileDuplicateEntrySet, secondSrc, secondFileContents, fileContentsIntersectionSet, isSameFile, treshold);
	
	return resultMap;
}

public DuplicateCodeRel createResultMap(loc firstSrc, set[list[int]] firstFileDuplicateEntrySet, loc secondSrc, list[str] secondFileContents, set[str] fileContentsIntersection, bool isSameFile, int treshold){
	DuplicateCodeRel resultMap = { <firstSrc, firstFileDuplicateEntrySet> };
	
	if(!isSameFile){
		secondFileDuplicateEntrySet = mapDuplicates(secondFileContents, fileContentsIntersection, isSameFile);
		resultMap += <secondSrc, filterSequencesByThreshold(secondFileDuplicateEntrySet,secondFileContents, treshold)>;
	}
	
	return resultMap;
}

public set[list[int]] filterSequencesByThreshold(set[list[int]] duplicationEntrySet, list[str] fileContents, int treshold){ 
	return { l | list[int] l <- duplicationEntrySet, size(l) >= treshold && size(l) < size(fileContents)};
}

public list[str] getIntersectionBetween(list[str] firstFileContents, list[str] secondFileContents, bool isSameFile){
	list[str] fileContentsIntersection = [];
	
	if(isSameFile){
		fileContentsIntersection = firstFileContents;
	}else{
		fileContentsIntersection =  firstFileContents & secondFileContents;
	}
	
	return fileContentsIntersection;
}

public set[list[int]] mapDuplicates(list[str] subjectList, set[str] needleList, bool isSameFile, int treshold=6){
	map[str, set[int]] duplicateEntryMap = ();
	map[int, list[int]] indListMap=();
	set[list[int]] result ={};
	str lineOfCode;
	int prevIndex = 0;
	
	for(int i <- [0..size(subjectList)]){
		lineOfCode = subjectList[i];
		
		if(lineOfCode in needleList){
			set[int] matchingElementList = duplicateEntryMap[lineOfCode]?{};
			matchingElementList += i+1;
			duplicateEntryMap[lineOfCode] = matchingElementList;

			list[int] indexList = indListMap[prevIndex]?[];
			indexList += i+1;
			indListMap[prevIndex] = indexList;
		}else{
			prevIndex = i + 1;
		}
	}
	
	if(isSameFile){
		//filter out the indexes that occured once (if the file is the same all lines will occur at least once)		
		list[int] sliceIndexes  = sort(({} | it + subSet | set[int] subSet <- { indexes | set[int] indexes <- range(duplicateEntryMap), size(indexes)>1 }));
		// gropu remaining indexes by sequence nr
		result += {slicedList | list[int] slicedList <- groupSequence(sliceIndexes), size(slicedList)>=treshold};
		
	}else{
		result = range(indListMap);
	}
	
	return result;
}

//https://www.geeksforgeeks.org/python-find-groups-of-strictly-increasing-numbers-in-a-list/
public list[list[int]] groupSequence(list[int] lst){
	
	if(size(lst) < 6) return [];
	lst = sort(lst);
    list[int] start_bound = [i | int i <- [0 .. size(lst)-1], (lst[i] != lst[i-1]+1) && lst[i + 1] == lst[i]+1];
    list[int] end_bound = [i | int i <- [1 .. size(lst)], lst[i] == lst[i-1]+1 && ((i == size(lst)-1)? true:lst[i + 1] != lst[i]+1)];
    return [lst[start_bound[i]..end_bound[i]+1] | int i <- [0 .. size(start_bound)]];  
}