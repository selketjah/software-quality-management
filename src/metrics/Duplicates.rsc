module metrics::Duplicates

import IO;
import List;
import util::Math;
import String;
import List;
import ListRelation;

import collections::Filter;
import cryptograhpy::Hash;
import \lexical::Import;
import metrics::Cache;
import metrics::Volume;
import structs::Duplicates;
import string::Trim;

public map[real, tuple[list[loc] locations, list[str] originalCode]] listClonesIn(loc firstSrc, str firstFileStr, loc secondSrc, str secondFileStr){	
	list[str] firstFileContents  = removeImports(stringToTrimmedList(firstFileStr));
	list[str] secondFileContents  = removeImports(stringToTrimmedList(secondFileStr));
	
	list[tuple[int startInd, int endInd]] duplicateLocations = [];
	map[real, tuple[list[loc] locations, list[str] originalCode]] duplicateCodeLocations = ();  
	
	bool duplicateCodeFound = false;
	int ind=0;
	//get largest piece of duplicate code in current file, remove from it and check again
	do{
		
		lrel[int, int] duplicateCodeRel = LCSubList((firstFileContents), (secondFileContents), size(firstFileContents), size(secondFileContents));
		
		//we have this block, now remove those lines from our base list and rerun
		//count number of successive lines until no references are left
		
		duplicateCodeFound =size(duplicateCodeRel)>5;
		
		if(duplicateCodeFound){

			tuple[int startInd, int endInd] currentDuplicate= <min(range(duplicateCodeRel)), max(range(duplicateCodeRel))>;		
			duplicateLocations += currentDuplicate;
			list[str] duplicatedLinesOfCodeList = secondFileContents[currentDuplicate.startInd .. currentDuplicate.endInd+1];
			real currentHash = computeHash(intercalate("", duplicatedLinesOfCodeList));
	
			if(currentHash in duplicateCodeLocations) {
				tuple[list[loc] locations, list[str] originalCode] duplicateCode= duplicateCodeLocations[currentHash];
				duplicateCode.locations = duplicateCode.locations + secondSrc;
			}else {
				duplicateCodeLocations[currentHash] = <[secondSrc], duplicatedLinesOfCodeList>;
			}
	
			list[str] tmpFileContents = secondFileContents[0..currentDuplicate.startInd];
			
			tmpFileContents += secondFileContents[currentDuplicate.endInd+1..size(secondFileContents)];
			
			secondFileContents = tmpFileContents;
		}
		duplicateCodeFound = duplicateCodeFound && size(secondFileContents)>5;
		
	}while(duplicateCodeFound);
	
	if(firstSrc == secondSrc){
		println("same file!");
	}
	
	return duplicateCodeLocations;
}

lrel[int, int] LCSubList(list[str] X, list[str] Y, int m, int n)  
{
	lrel[int, int] dupCodePos =[];
    // Create a table to store lengths of longest common suffixes of 
    // substrings. Note that LCSuff[i][j] contains length of longest 
    // common suffix of X[0..i-1] and Y[0..j-1]. The first row and 
    // first column entries have no logical meaning, they are used only 
    // for simplicity of program 
    map[int, map[int, int]] LCStuff = (mI:(nI:0 | int nI <- [0..n])  | int mI  <- [0 .. m]);
    int result = 0;  // To store length of the longest common substring 
    // Following steps build LCSuff[m+1][n+1] in bottom up fashion 
    for(int i  <- [0 .. m])
    { 
        for (int j <- [0..n])  
        {
            if (i == 0 || j == 0){
                LCStuff[i][j] = 0;
            } 
            else if (X[i - 1] == Y[j - 1]) 
            {
                LCStuff[i][j] = LCStuff[i - 1][j - 1] + 1;
                int tmpResult = max(result, LCStuff[i][j]);
                if(result != tmpResult){
                	if(size(dupCodePos)==0){
                		dupCodePos +=<i-1,j-1>;	
                	}
                	
                	dupCodePos +=<i,j>;
                	result = tmpResult;
                }
            }
            else{
                LCStuff[i][j] = 0;
            } 
        } 
    }
    
    return dupCodePos; 
}
