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
import scoring::Percentage;
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

import visualization::Dashboard;
import structs::Visualization;

import collections::Filter;

public void main(){
	//calculateSIG(|project://JabberPoint|);
	calculateSIG(|project://smallsql|);
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
	
	//println("calculate clones");
	DuplicateCodeRel duplicationRel = calculateDuplicates(methodHolders, compilationUnitMap);
	//println("calculate CC");
	compilationUnitMetricSet += {calculateUnitMetrics(src, methodSizeRel) | <loc name, loc src> <- methodHolders};
	//println("calculate unit test coverage");
	UnitTestCoverageMap unitTestCoverageMap = createUnitTestCoverageMap(methodSizeRel,methods, compilationUnitMap, currentProjectModel);
	
	volume = ((0 | it + compilationUnitSizeRel[src] | loc src  <- compilationUnitSizeRel));
	
	Average averages = calculateAverages(compilationUnitMetricSet);
	Percentages percentages = calculatePercentages(volume, duplicationRel, unitTestCoverageMap);
	
	Metrics metrics = <volume, compilationUnitMetricSet, percentages>;
	Ranks ranks = determineRanks(metrics);
	
	renderDashboard(<project, metrics, size(methods), averages, ranks>);
}
	
public list[int] mergeList(list[int] xList, list[int] yList){
	return merge(xList, yList);
}
