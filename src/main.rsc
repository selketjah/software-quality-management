module main

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import List;
import Message;
import Set;
import Map;
import Relation;
import util::Benchmark;
import util::Math;
import util::Resources;
import analysers::LocAnalyser;
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

import String;

public void main(){
	//calculateSIG(|project://Jabberpoint-le3|);
	//calculateSIG(|project://smallsql|);
	calculateSIG(|project://hsqldb|);
}

public void calculateSIG(loc project){
	M3 currentProject = createM3FromEclipseProject(project);
	int numberOfDuplicateLines=0;
	rel[loc name,loc src] compilationUnits = {<name,src> | <loc name, loc src> <- currentProject.declarations, isCompilationUnit(name)}; 
	rel[loc name,loc src] methodHolders = {<name,src> | <loc name, loc src> <- currentProject.declarations, canContainMethods(name) && !isAnonymousClass(name)};
	
	list[loc] methodHolderDup = toList(range(methodHolders));
	
	rel[loc name,loc src] methods = {<name,src> | <loc name, loc src> <- currentProject.declarations, isMethod(name)};
	rel[loc, set[list[int]]] duplicationMap={};
	map[loc src, list[str] linesOfCode] compilationUnitMap = (src:srcToLoc(src) | <loc name, loc src> <- compilationUnits)
															 + (src:srcToLoc(src) | <loc name, loc src> <- methodHolders)
															 + (src:srcToLoc(src) | <loc name, loc src> <- methods);

	list[ComponentLOC] compilationUnitSizeList = [calculateLinesOfCode(src, compilationUnitMap[src]) | <loc name, loc src> <- compilationUnits];
	list[ComponentLOC] methodHolderSizeList = [calculateLinesOfCode(src, compilationUnitMap[src]) | <loc name, loc src> <- methodHolders];
	list[ComponentLOC] methodsSizeList = [calculateLinesOfCode(src, compilationUnitMap[src]) | <loc name, loc src> <- methods];
	list[CompilationUnitComplexity] complexityList = [];
	
	//O(N log N)
	println("checking for duplicates");

	for(loc src <- toList(range(methodHolders))){
		complexityList+=calculateFileCyclomaticComplexity(src);
		for(loc src2 <- methodHolderDup){
			duplicationMap += listClonesIn(src, compilationUnitMap[src],src2, compilationUnitMap[src2]);
		}
		methodHolderDup = delete(methodHolderDup,indexOf(methodHolderDup, src));				
	}
	
	volume = ((0.0 | it + componentLoc.size | ComponentLOC componentLoc <- compilationUnitSizeList));
}
