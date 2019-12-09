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
import metrics::Volume;
import analysers::LocAnalyser;
import util::Resources;
import Relation;
import Set;
import util::Benchmark;
import analysis::m3::Registry;


public void calculateSIG(loc project){
	int timeInNanoSecondsBeforeRun = cpuTime();
	set[CompilationUnitLoc] projectCULocCollection = calculatePhysicalLinesOfCode(project);
	
	int numberOfFiles = size(projectCULocCollection);
	int numberOfStrucDefinitions = 0;
	int linesOfCode = 0;
	
	for(CompilationUnitLoc cuLoc <- projectCULocCollection){
		numberOfStrucDefinitions = numberOfStrucDefinitions + size(cuLoc.strucUnitLoc);
		linesOfCode = linesOfCode + cuLoc.compilationUnit.size;
	}
	
	println("numberOfFiles <numberOfFiles>");
	println("numberOfStructDefinition (class, enum, interface, anonymous) <numberOfStrucDefinitions>" );
	println("Total lines Of Code: <linesOfCode>");
	
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");
}



public void main(){
	
	println("Calculate LOC for jabberpoint");
	calculateSIG(|project://Jabberpoint-le3|);
	
	println("Calculate LOC for smqllSQL");
	//calculateSIG(|project://smallsql|);
	
	println("Calculate LOC for hsqldb");
	calculateSIG(|project://hsqldb|);
}