module main

import Message;
import Set;
import IO;
import String;
import List;
import Map;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysers::LocAnalyser;
import util::Resources;
import Relation;
import Set;
import util::Benchmark;
import analysis::m3::Registry;
import metrics::Volume;
import scoring::categories::Volume;
import scoring::Rank;
import metrics::Cache;
import metrics::Duplicates;
import metrics::Complexity;
import util::Resources;
import metrics::UnitTestCoverage;

public void calculateSIG(list[loc] fileLocations){
	int timeInNanoSecondsBeforeRun = cpuTime();

	int numberOfStrucDefinitions = 0;
	int linesOfCode = 0;
	int numberOfMethods = 0;
	int totalNumberOfAsserts = 0;
	set[CompilationUnitLoc] projectCULocCollection = {};
	set[CompilationUnitComplexity] compilationUnitComplexitySet = {};
	list[AssertCount] assertCounts=[];
	list[str] currentFileContents=[];
	CompilationUnitComplexity compilationUnitComplexity;
	AssertCount assertCount;
	CompilationUnitLoc compilationUnitLoc;
	list[loc] fileLocationsDuplicateList = fileLocations;
	loc locationToBeRemoved;
	int customCount = 0;
	
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
			
			findDuplicates(stringToTrimmedList(firstFileContents), stringToTrimmedList(secondFileContents));
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
