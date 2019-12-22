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
	
	list[str] intersectedPart = firstFileContents & secondFileContents;
	
	if(size(intersectedPart) < treshold){ return 0; }
	
	int sum=0;
	list[real] subjectHashes =[];
	list[real] referenceHashes = createHashesFromFile(firstFileContents, treshold);
	if(!isSameFile){
		subjectHashes = createHashesFromFile(intersectedPart, treshold);
	}else{
		subjectHashes = referenceHashes;
	}
	
	if(!isSameFile){
		list[real] intersectedHashes = referenceHashes & subjectHashes;
		list[real] resultList=[];
		
		if(size(intersectedHashes)>0){
			int previousIndex =0;
			for(real intersectHash <- intersectedHashes){
				int referenceIndex = indexOf(referenceHashes, intersectHash);
				if(referenceIndex-1 != previousIndex){
				//}else{
					resultList += intersectHash;
					previousIndex=referenceIndex;
				}
			}
			
			if(size(resultList)+1 > 5-1){
				//these should be conseucutive lines...
				println("duplicate counts <size(resultList)+1>");
			}			
		}
	}
	
	return sum;
}

public list[real] createHashesFromFile(list[str] fileContents, int treshold){
	return [computeHash(subj)| str subj <- fileContents];
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