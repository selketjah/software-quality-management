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
	int linesOfCode = calculatePhysicalLinesOfCode(project);
	println("Lines Of Code: <linesOfCode>");
	println("It took <(cpuTime() - timeInNanoSecondsBeforeRun)/pow(10,9)>s");
}

public void calculateMethodSize(loc file){
	Declaration fileDec = createAstFromFile(file, false);
	M3 fileM3Model = createM3FromFile(file);
	println("total file size for <file> <calculateLinesOfCode(file).size>");
	rel[loc name,loc src] decls = fileM3Model.declarations;
	
	for(<loc name, loc src> <- decls){
		if(isMethod(name) || isClass(name)) {
			println("<name> = <calculateLinesOfCode(src).size>");
		}
	}
}

public void main(){
	println("Calculating Unit Size for Jabberpoint-le3/src/Style.java");
	calculateMethodSize(|project://Jabberpoint-le3/src/Style.java|);
	
	println("Calculate LOC for jabberpoint");
	calculateSIG(|project://Jabberpoint-le3|);
	
	println("Calculate LOC for smqllSQL");
	calculateSIG(|project://smallsql|);
	
	println("Calculate LOC for hsqldb");
	calculateSIG(|project://hsqldb|);
}