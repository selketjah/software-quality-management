module metrics::Duplicates

import IO;
import List;
import Set;
import util::Math;
import String;
import List;
import ListRelation;
import Map;

import collections::Filter;
import cryptograhpy::Hash;
import \lexical::Import;
import metrics::Cache;
import metrics::Volume;
import structs::Duplicates;
import string::Trim;


// O(n)
public rel[loc, set[list[int]]] listClonesIn(loc firstSrc, list[str] firstFileContents, loc secondSrc, list[str] secondFileContents, int treshold = 6){
	bool isSameFile = firstSrc == secondSrc;
	rel[loc, set[list[int]]] resultMap={};
	list[str] fileContentsIntersection = secondFileContents & firstFileContents;
	
	 
	if(size(fileContentsIntersection)<treshold){
		return {};
	}
	
	if(isSameFile){
		fileContentsIntersection = firstFileContents;
	}
	
	set[list[int]] firstFileDuplicateEntrySet = mapDuplicates(firstFileContents, fileContentsIntersection, isSameFile);
	set[list[int]] secondFileDuplicateEntrySet;
	
	firstFileDuplicateEntrySet = { l | list[int] l <- firstFileDuplicateEntrySet, size(l)>=treshold && size(l) < size(firstFileContents)};
	resultMap = {<firstSrc, firstFileDuplicateEntrySet>}; 
	
	if(!isSameFile){
		secondFileDuplicateEntrySet = mapDuplicates(secondFileContents, fileContentsIntersection, isSameFile);
		resultMap += <secondSrc, { l | list[int] l <- secondFileDuplicateEntrySet, size(l)>=treshold && size(l) < size(secondFileContents)}>;
	}
	
	return resultMap;
}

public set[list[int]] mapDuplicates(list[str] subjectList, list[str] needleList, bool isSameFile, int treshold=6){
	map[str, set[int]] duplicateEntryMap = ();
	map[int, list[int]] indListMap=();
	set[list[int]] result ={};
	str lineOfCode;
	
	for(int i <- [0..size(subjectList)]){
		lineOfCode = subjectList[i];
		
		if(lineOfCode in needleList){
			if(lineOfCode in duplicateEntryMap){
				set[int] matchingElementList = duplicateEntryMap[lineOfCode];
				matchingElementList += i;
				duplicateEntryMap[lineOfCode] = matchingElementList;
			}else{
				duplicateEntryMap[lineOfCode] = {i};
			}
			
			if(i-1 in indListMap){
				list[int] indexList = indListMap[i-1];
				indexList += i;
				indListMap = delete(indListMap, i-1);
				indListMap[i] = indexList;
			}else{
				indListMap[i]=[i];
			}
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
	//lst = quickSort(lst, 0, size(lst)-1);
	lst=sort(lst);
    list[int] start_bound = [i | int i <- [0 .. size(lst)-1], (lst[i] != lst[i-1]+1) && lst[i + 1] == lst[i]+1];
    list[int] end_bound = [i | int i <- [1 .. size(lst)], lst[i] == lst[i-1]+1 && ((i == size(lst)-1)? true:lst[i + 1] != lst[i]+1)];
    return [lst[start_bound[i]..end_bound[i]+1] | int i <- [0 .. size(start_bound)]];
    
}