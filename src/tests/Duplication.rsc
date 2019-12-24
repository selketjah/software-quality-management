module tests::Duplication

import util::Math;
import metrics::Volume;
import IO;
import String;
import List;
import string::Trim;
import ListRelation;
import cryptograhpy::Hash;

public test bool longestListSubStringTest(){
	
	str firstFileStr= getCompilationUnitAsStringWithoutComments(|project://sqm-assignment/src/tests/data/Style.java|);
	str secondFileStr= getCompilationUnitAsStringWithoutComments(|project://sqm-assignment/src/tests/data/TextItem.java|);
	
	list[str] firstFileContents  = trimTerminalChars(stringToTrimmedList(firstFileStr));
	list[str] secondFileContents  = trimTerminalChars(stringToTrimmedList(secondFileStr));
	
	//println(firstFileContents);
	bool hasDuplicates = false;
	//get largest piece of duplicate code in current file
	do{
		//println(size(secondFileContents));
		lrel[int, int] duplicateCodeRel = LCSubList(createHashes(firstFileContents), createHashes(secondFileContents), size(firstFileContents), size(secondFileContents));
		//we have this block, now remove those lines from our base list and rerun
		// count number of successive lines
		//println(secondFileContents[min(range(duplicateCodeRel))]);
		
		tuple[int startInd, int endInd] currentDuplicate= <min(domain(duplicateCodeRel)), max(domain(duplicateCodeRel))>;
		
		// remove from second suspect
		int refSize = size(secondFileContents);
		list[str] tmpFileContents = secondFileContents[0..min(range(duplicateCodeRel))];
		tmpFileContents += secondFileContents[max(range(duplicateCodeRel))+1..size(secondFileContents)];
		secondFileContents = tmpFileContents;
		
		//println("<refSize - size(secondFileContents)> == <size(duplicateCodeRel)>");
		println(currentDuplicate);
		hasDuplicates = size(duplicateCodeRel)>5 && size(secondFileContents)>5;

	}while(hasDuplicates);
	
	//remove duplicate part and recheck
	
	//for(<int i, int j> <- duplicateCodeRel){
	//	println("<firstFileContents[i]> \>\>\> <secondFileContents[j]>");
	//}
	
	return size([]) >= 6;
}

public list[real] createHashes(list[str] fileContents){
	return [computeHash(subj)| str subj <- fileContents];
}

lrel[int, int] LCSubList(list[real] X, list[real] Y, int m, int n)  
{
	lrel[int, int] dupCodePos =[];
    // Create a table to store lengths of longest common suffixes of 
    // substrings. Note that LCSuff[i][j] contains length of longest 
    // common suffix of X[0..i-1] and Y[0..j-1]. The first row and 
    // first column entries have no logical meaning, they are used only 
    // for simplicity of program 
    //int LCStuff[][] = new int[m + 1][n + 1];
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
