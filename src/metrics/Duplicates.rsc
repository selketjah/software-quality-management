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
import structs::Duplicates;
import string::Trim;

public DuplicateCodeRel calculateDuplicates(rel[loc name,loc src] methodHolders, map[loc src, list[str] linesOfCode] compilationUnitMap){
	DuplicateCodeRel duplicationRel = {};
	list[loc] methodHolderDup = toList(range(methodHolders));
	//O(N log N)
	for(loc src <- toList(range(methodHolders))){
		for(loc src2 <- methodHolderDup){
			DuplicateCodeRel codeRel = listClonesIn(src, compilationUnitMap[src],src2, compilationUnitMap[src2]);
			duplicationRel += codeRel;
		}
		methodHolderDup = delete(methodHolderDup,indexOf(methodHolderDup, src));
	} 
	
	return duplicationRel;
}

// O(n)
public DuplicateCodeRel listClonesIn(loc firstSrc, list[str] firstFileContents, loc secondSrc, list[str] secondFileContents, int treshold = 6){
	bool isSameFile = firstSrc == secondSrc;
	DuplicateCodeRel resultMap={};
	list[str] fileContentsIntersection = secondFileContents & firstFileContents;
	
	if(size(fileContentsIntersection)<treshold){
		return {};
	}
	
	if(isSameFile){
		fileContentsIntersection = firstFileContents;
	}
	
	set[list[int]] firstFileDuplicateEntrySet = mapDuplicates(firstFileContents, toSet(fileContentsIntersection), isSameFile);
	set[list[int]] secondFileDuplicateEntrySet;
	
	firstFileDuplicateEntrySet = { l | list[int] l <- firstFileDuplicateEntrySet, size(l) >= treshold && size(l) < size(firstFileContents)};

	if(!isSameFile){
		resultMap = { <firstSrc, firstFileDuplicateEntrySet> };
		secondFileDuplicateEntrySet = mapDuplicates(secondFileContents, toSet(fileContentsIntersection), isSameFile);
		resultMap += <secondSrc, { l | list[int] l <- secondFileDuplicateEntrySet, size(l) >= treshold && size(l) < size(secondFileContents)}>;
	}else{ 
		resultMap = { <firstSrc, firstFileDuplicateEntrySet> };
	}
	
	return resultMap;
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
			matchingElementList += i;
			duplicateEntryMap[lineOfCode] = matchingElementList;

			list[int] indexList = indListMap[prevIndex]?[];
			indexList += i;
			indListMap[prevIndex] = indexList;
		}else{
			prevIndex = i;
		}
	}
	
	if(isSameFile){
		list[int] refIndexList = toList(range(indListMap))[0];
		
		if(size(refIndexList) == size(subjectList)){
			list[int] sliceIndexes  = sort(({} | it + subSet | set[int] subSet <- { indexes | set[int] indexes <- range(duplicateEntryMap), size(indexes)>1 }));
			
			result += {slicedList | list[int] slicedList <- groupSequence(sliceIndexes), size(slicedList)>=treshold};
		}
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