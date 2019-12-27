module main

import IO;
import lang::java::m3::Core;
import List;
import Message;
import Set;
import util::Benchmark;
import util::Math;
import util::Resources;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;

import string::Trim;
import metrics::Cache;
import metrics::Complexity;
import metrics::Duplicates;
import metrics::UnitTestCoverage;
import metrics::Volume;
import metrics::UnitMetrics;
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
	list[AssertCount] assertCounts=[];
	list[str] currentFileContents=[];
	
	AssertCount assertCount;
	CompilationUnitLoc compilationUnitLoc;
	
	set[CompilationUnitMetric] compilationUnitMetricSet = {};
	CompilationUnitMetric compilationUnitMetric;
	
	
	list[loc] fileLocationsDuplicateList = fileLocations;
	loc locationToBeRemoved;
	
	for(loc fileLoc <- fileLocations){
		
		compilationUnitLoc = calculateUnitSize(fileLoc);
		compilationUnitMetric = calculateUnitMetrics(fileLoc);
		assertCount = countAssertsInFile(fileLoc);
				
		projectCULocCollection += compilationUnitLoc;
		assertCounts += assertCount;		
		compilationUnitMetricSet += compilationUnitMetric;
		
		numberOfStrucDefinitions += size(compilationUnitLoc.strucUnitLoc);
		numberOfMethods += size(compilationUnitLoc.componentUnitLocCollection);
		linesOfCode += compilationUnitLoc.compilationUnit.size;	
		totalNumberOfAsserts += assertCount.count;
		
		fileLocationsDuplicateList = delete(fileLocationsDuplicateList,indexOf(fileLocationsDuplicateList, fileLoc));

		for(loc file2Loc <- fileLocationsDuplicateList){
			str tmp = ("duplication check should go here");
		}
	}
	
	Metrics metrics = <linesOfCode, compilationUnitMetricSet, 0, totalNumberOfAsserts>;
	Ranks ranks = determineRanks(metrics);
	Average averages = calculateAverages(compilationUnitMetricSet);
	
	
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");
}

public void main(){
	Resource currentProjectResource = getProject(|project://JabberPoint|);
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
