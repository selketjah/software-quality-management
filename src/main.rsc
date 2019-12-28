module main

import IO;
import lang::java::m3::Core;
import List;
import Message;
import Set;
import Map;
import util::Benchmark;
import util::Math;
import util::Resources;

import scoring::Rank;
import scoring::categories::Volume;
import string::Trim;
import metrics::Cache;
import metrics::Complexity;
import metrics::Duplicates;
import metrics::UnitTestCoverage;
import metrics::Volume;
import resource::IO;

import collections::Filter;
import \lexical::Import;

import String;

public void calculateSIG(list[loc] fileLocations){
	int timeInNanoSecondsBeforeRun = cpuTime();

	int numberOfStrucDefinitions = 0;
	int linesOfCode = 0;
	int numberOfMethods = 0;
	int totalNumberOfAsserts = 0;
	int customCount = 0;
	set[CompilationUnitLoc] projectCULocCollection = {};
	set[CompilationUnitComplexity] compilationUnitComplexitySet = {};
	list[AssertCount] assertCounts=[];
	list[str] currentFileContents=[];
	CompilationUnitComplexity compilationUnitComplexity;
	AssertCount assertCount;
	CompilationUnitLoc compilationUnitLoc;
	list[loc] fileLocationsDuplicateList = fileLocations;
	map[loc, str] fileDataMap = ();
	loc locationToBeRemoved;
	str firstFileContents;
	str secondFileContents;
	int numberOfFiles = size(fileLocations);
	int currentCloneMapSize=0;
	map[real, tuple[list[loc] locations, list[str] originalCode]] duplicateLocations = ();
	
	for(loc fileLoc <- fileLocations){
		
		if(fileLoc in fileDataMap){
			firstFileContents = fileDataMap[fileLoc];
		}else {
			firstFileContents = getCompilationUnitAsStringWithoutComments(fileLoc);
			fileDataMap += (fileLoc:firstFileContents);
		}
		
		compilationUnitLoc = calculateUnitSize(fileLoc);
		compilationUnitComplexity = calculateFileCyclomaticComplexity(fileLoc, firstFileContents);
		assertCount= countAssertsInFile(fileLoc);
				
		projectCULocCollection += compilationUnitLoc;
		assertCounts += assertCount;		
		compilationUnitComplexitySet += compilationUnitComplexity;
		
		numberOfStrucDefinitions += size(compilationUnitLoc.strucUnitLoc);
		linesOfCode += compilationUnitLoc.compilationUnit.size;	
		totalNumberOfAsserts += assertCount.count;
		

		for(loc file2Loc <- fileLocationsDuplicateList){
			if(file2Loc in fileDataMap){
				secondFileContents = fileDataMap[file2Loc];
			}else {
				secondFileContents = getCompilationUnitAsStringWithoutComments(file2Loc);
				fileDataMap += (file2Loc:secondFileContents);
			}
			
			map[real, tuple[list[loc] locations, list[str] originalCode]] currentlyDetectedClonesMap = listClonesIn(fileLoc, firstFileContents,file2Loc, secondFileContents);
			currentCloneMapSize =  size(currentlyDetectedClonesMap);
			if(currentCloneMapSize > 0){
				//duplicateLocations += currentlyDetectedClonesMap;
				println("number of duplicates found in <fileLoc> and <file2Loc>: <size(range(currentlyDetectedClonesMap))>");
			}
		}
		
				fileLocationsDuplicateList = delete(fileLocationsDuplicateList,indexOf(fileLocationsDuplicateList, fileLoc));
		
	}
	
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");
	
	//println(duplicateLocations);
}

public void main(){
	Resource currentProjectResource = getProject(|project://Jabberpoint-le3|);
	list[loc] fileLocations = listFiles(currentProjectResource);
	
	//println("SIG MODEL Measurements for jabberpoint");
	//calculateSIG(fileLocations);
	
	println("SIG MODEL Measurements for smallSQL");
	currentProjectResource = getProject(|project://smallsql|);
	fileLocations = listFiles(currentProjectResource);
	calculateSIG(fileLocations);
	
	//println("SIG MODEL Measurements for hsqldb");
	//currentProjectResource = getProject(|project://hsqldb|);
	//fileLocations = listFiles(currentProjectResource);
	//calculateSIG(fileLocations);
}
