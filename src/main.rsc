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
import scoring::Ranking;
import scoring::Average;
import String;

import analysers::M3Analyser; 
import metrics::Cache;
import metrics::Complexity;
import metrics::Duplicates;
import metrics::UnitTestCoverage;
import metrics::Volume;
import metrics::UnitMetrics;
import resource::IO;
import string::Print;
import string::Trim;
import structs::Duplicates;

import collections::Filter;

public void main(){
	calculateSIG(|project://Jabberpoint-le3|);
	//calculateSIG(|project://smallsql|);
	//calculateSIG(|project://hsqldb|);
}

public void calculateSIG(loc project){
	M3 currentProjectModel = createM3FromEclipseProject(project);
	
	set[CompilationUnitMetric] compilationUnitMetricSet = {};
	
	rel[loc name,loc src] compilationUnits = getCompilationUnitsFromM3(currentProjectModel);  
	rel[loc name,loc src] methodHolders = getMethodHoldingDeclerationsFromM3(currentProjectModel);
	rel[loc name,loc src] methods = getMethodsFromM3(currentProjectModel);
	map[loc src, list[str] linesOfCode] compilationUnitMap = getLinesOfCode(compilationUnits, methodHolders, methods); 
		
	ComponentLOC compilationUnitSizeRel = calculateLinesOfCode(compilationUnits, compilationUnitMap);
	ComponentLOC methodHolderSizeRel = calculateLinesOfCode(methodHolders, compilationUnitMap);
	ComponentLOC methodSizeRel = calculateLinesOfCode(methods, compilationUnitMap);
	
	println("checking for duplicates");
	DuplicateCodeRel duplicationRel = calculateDuplicates(methodHolders, compilationUnitMap);
	compilationUnitMetricSet += {calculateUnitMetrics(src, methodSizeRel) | <loc name, loc src> <- methodHolders};
		
	volume = ((0 | it + size | <loc src, int size>  <- compilationUnitSizeRel));
	Metrics metrics = <volume, compilationUnitMetricSet, 15, 0>;
	Ranks ranks = determineRanks(metrics);
	Average averages = calculateAverages(compilationUnitMetricSet);
	
	printResult(volume, size(methods), 15, averages, ranks);
}
