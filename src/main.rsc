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
import structs::Ranking;
import string::Print;
import visualization::Visualization;

import Cache::ProjectCache;
import structs::Analysis;


public void main(){
	ProjectVisData projectData;
	
	//projectData = retrieveProjectData(|project://JabberPoint|);
	projectData = retrieveProjectData(|project://smallsql|);
	//projectData = retrieveProjectData(|project://hsqldb|);
	
	initializeVisualization(projectData);
}

public ProjectVisData retrieveProjectData(loc project){
	ProjectData projectData;
	SigMetricsResults metricData;
	
	M3 currentProjectModel = createM3FromEclipseProject(project);
	
	//if(wasAlreadyCalculated(project)){
	//	metricData = loadProjectData(project);
	//}else{
		metricData = calculateMetrics(currentProjectModel);
		//saveProjectData(project, metricData);
	//}
	
	Ranks ranks = determineRanks(metricData.metrics);
	projectData = <metricData.metrics, metricData.duplication, metricData.methods, ranks, metricData.unitTestCoverageMap>;
	
	//printResult(metricData.volume, size(metricData.methods), metricData.percentages, ranks);
	
	return <project, currentProjectModel, projectData>;
}

public SigMetricsResults calculateMetrics(M3 currentProjectModel){

	set[CompilationUnitMetric] compilationUnitMetricSet = {};
	
	rel[loc name,loc src] compilationUnits = getCompilationUnitsFromM3(currentProjectModel);  
	rel[loc name,loc src] methodHolders = getMethodHoldingDeclerationsFromM3(currentProjectModel);
	rel[loc name,loc src] methods = getMethodsFromM3(currentProjectModel);
	
	map[loc src, list[str] linesOfCode] compilationUnitMap = getLinesOfCodeByType(compilationUnits, methodHolders, methods); 
	
	ComponentLOC compilationUnitSizeRel = calculateLinesOfCode(compilationUnits, compilationUnitMap);
	ComponentLOC methodHolderSizeMap = calculateLinesOfCode(methodHolders, compilationUnitMap);
	ComponentLOC methodSizeRel = calculateLinesOfCode(methods, compilationUnitMap);
	
	tuple[DuplicateCodeRel duplicationRel, rel[loc, loc] duplicationLocationRel] duplication = calculateDuplicates(methodHolders, compilationUnitMap);
	
	compilationUnitMetricSet += { calculateUnitMetrics(src, methodSizeRel) | <loc name, loc src> <- methodHolders };
	
	map[loc, int] methodComplexityMap = createMethodComplexityMap(compilationUnitMetricSet);

	UnitTestCoverageMap unitTestCoverageMap = createUnitTestCoverageMap(methodSizeRel, methods, compilationUnitMap, methodComplexityMap, currentProjectModel);
	
	volume = ((0 | it + compilationUnitSizeRel[src] | loc src  <- compilationUnitSizeRel));
	
	Percentages percentages = calculatePercentages(volume, compilationUnitMetricSet, duplication.duplicationRel, methodComplexityMap, unitTestCoverageMap);
	Metrics metrics = <volume, compilationUnitMetricSet, <compilationUnitSizeRel, methodHolderSizeMap, methodSizeRel>, percentages>;
	
	return <metrics, duplication, methods, volume, percentages, unitTestCoverageMap>;
}
