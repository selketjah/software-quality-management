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
import String;

import analysers::LocAnalyser;
import analysers::M3Analyser; 
import collections::Filter;
import metrics::Cache;
import metrics::Complexity;
import metrics::Duplicates;
import metrics::UnitTestCoverage;
import metrics::Volume;
import metrics::UnitMetrics;
import resource::IO;
import scoring::Average;
import scoring::Percentage;
import scoring::Rank;
import scoring::Ranking;
import string::Print;
import string::Trim;
import structs::Duplication;
import structs::UnitMetrics;
import structs::Visualization;
import structs::Volume;
import structs::Average;
import structs::Percentage;
import structs::UnitTestCoverage;
import visualization::Visualization;
import structs::Ranking;
import string::Print;

public void main(){
	calculateSIG(|project://JabberPoint|);
	//calculateSIG(|project://smallsql|);
	//calculateSIG(|project://hsqldb|);
}

public void calculateSIG(loc project){
	M3 currentProjectModel = createM3FromEclipseProject(project);
	
	set[CompilationUnitMetric] compilationUnitMetricSet = {};
	
	rel[loc name,loc src] compilationUnits = getCompilationUnitsFromM3(currentProjectModel);  
	rel[loc name,loc src] methodHolders = getMethodHoldingDeclerationsFromM3(currentProjectModel);
	rel[loc name,loc src] methods = getMethodsFromM3(currentProjectModel);
	
	map[loc src, list[str] linesOfCode]  compilationUnitMap = getLinesOfCode2(compilationUnits, methodHolders, methods); 
	
	ComponentLOC compilationUnitSizeRel = calculateLinesOfCode(compilationUnits, compilationUnitMap);
	ComponentLOC methodHolderSizeRel = calculateLinesOfCode(methodHolders, compilationUnitMap);
	ComponentLOC methodSizeRel = calculateLinesOfCode(methods, compilationUnitMap);
	
	tuple[DuplicateCodeRel duplicationRel, rel[loc, loc] duplicationLocationRel] duplication = calculateDuplicates(methodHolders, compilationUnitMap);
	
	compilationUnitMetricSet += { calculateUnitMetrics(src, methodSizeRel) | <loc name, loc src> <- methodHolders };
	
	map[loc, int] methodComplexityMap = createMethodComplexityMap(compilationUnitMetricSet);
	
	UnitTestCoverageMap unitTestCoverageMap = createUnitTestCoverageMap(methodSizeRel, methods, compilationUnitMap, methodComplexityMap, currentProjectModel);
	
	volume = ((0 | it + compilationUnitSizeRel[src] | loc src  <- compilationUnitSizeRel));
	
	Average averages = calculateAverages(compilationUnitMetricSet);
	Percentages percentages = calculatePercentages(volume, duplication.duplicationRel, sum(range(methodComplexityMap)), unitTestCoverageMap);
	
	Metrics metrics = <volume, compilationUnitMetricSet, percentages>;
	Ranks ranks = determineRanks(metrics);
	println(size(methods));
	//printResult(volume, size(methods), percentages, averages, ranks);
	initializeVisualization(<project, currentProjectModel, metrics, duplication.duplicationLocationRel, size(methods), averages, ranks>);
}

public void tests(){
	loc project  =|project://JabberPoint|;

	M3 currentProjectModel = createM3FromEclipseProject(project);
	
	list[loc] allFromCanContainMethods = [src| loc src <- domain(currentProjectModel.typeDependency), canContainMethods(src) 
															&& (!isEmpty(currentProjectModel.declarations[src]))];

	println(allFromCanContainMethods);
	
}