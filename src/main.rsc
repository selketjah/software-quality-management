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
import util::Resources;

public void calculateSIG(loc project){
	int timeInNanoSecondsBeforeRun = cpuTime();
	Resource currentProjectResource = getProject(project);
	list[loc] fileLocations = listFiles(currentProjectResource);
	set[CompilationUnitLoc] projectCULocCollection = calculatePhysicalLinesOfCode(fileLocations);
	
	int numberOfFiles = size(projectCULocCollection);
	int numberOfStrucDefinitions = 0;
	int linesOfCode = 0;
	int numberOfMethods = 0;
	list[ComponentLOC] methodCollection = [];
	for(CompilationUnitLoc cuLoc <- projectCULocCollection){
		numberOfStrucDefinitions = numberOfStrucDefinitions + size(cuLoc.strucUnitLoc);
		methodCollection = methodCollection + cuLoc.componentUnitLocCollection;
		linesOfCode = linesOfCode + cuLoc.compilationUnit.size;
	}
	
	println("numberOfFiles <numberOfFiles>");
	println("numberOfStructDefinition (class, enum, interface, anonymous) <numberOfStrucDefinitions>" );
	println("numberOfMethods <size(methodCollection)>");
	println("Total lines Of Code: <linesOfCode>");
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");

	println(detectClones(methodCollection));
}

public void main(){
	
	println("Calculate LOC for jabberpoint");
	calculateSIG(|project://Jabberpoint-le3|);
	
	println("Calculate LOC for smallSQL");
	//calculateSIG(|project://smallsql|);
	
	//println("Calculate LOC for hsqldb");
	//calculateSIG(|project://hsqldb|);
}
