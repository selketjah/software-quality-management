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
import util::Resources;
import Relation;
import Set;
import util::Benchmark;


public void calculateSIG(loc project){
	int timeInNanoSecondsBeforeRun = cpuTime();
	int linesOfCode = calculatePhysicalLinesOfCode(project);
	println("Lines Of Code: <linesOfCode>");
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");
}