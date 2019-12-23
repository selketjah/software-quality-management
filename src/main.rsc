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
	loc locationToBeRemoved;
	
	for(loc fileLoc <- fileLocations){
		
		compilationUnitLoc = calculateUnitSize(fileLoc);
		compilationUnitComplexity = calculateFileCyclomaticComplexity(fileLoc);
		assertCount= countAssertsInFile(fileLoc);
				
		projectCULocCollection += compilationUnitLoc;
		assertCounts += assertCount;		
		compilationUnitComplexitySet += compilationUnitComplexity;
		
		numberOfStrucDefinitions += size(compilationUnitLoc.strucUnitLoc);
		linesOfCode += compilationUnitLoc.compilationUnit.size;	
		totalNumberOfAsserts += assertCount.count;
		
		fileLocationsDuplicateList = delete(fileLocationsDuplicateList,indexOf(fileLocationsDuplicateList, fileLoc));

		for(loc file2Loc <- fileLocationsDuplicateList){
			str firstFileContents = getCompilationUnitAsStringWithoutComments(fileLoc);
			str secondFileContents = getCompilationUnitAsStringWithoutComments(file2Loc);
			
			map[real, tuple[list[loc] locations, list[str] originalCode]] duplicateLocations = listClonesIn(fileLoc, file2Loc);
			
			if(size(duplicateLocations)>0){
				println(size(duplicateLocations));
			}
		}
	}
	
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");
}

public void main(){
	Resource currentProjectResource = getProject(|project://Jabberpoint-le3|);
	list[loc] fileLocations = listFiles(currentProjectResource);
	
	println("SIG MODEL Measurements for jabberpoint");
	calculateSIG(fileLocations);
	
	println("SIG MODEL Measurements for smallSQL");
	currentProjectResource = getProject(|project://smallsql|);
	fileLocations = listFiles(currentProjectResource);
	//calculateSIG(fileLocations);
	
	println("SIG MODEL Measurements for hsqldb");
	//calculateSIG(|project://hsqldb|);
}
