module analysers::M3Analyser

import lang::java::m3::Core;
import analysers::LocAnalyser;
import metrics::Volume;

import IO;

public rel[loc name,loc src] getCompilationUnitsFromM3(M3 model){
	return {<name,src> | <loc name, loc src> <- model.declarations, isCompilationUnit(name)};
}

public rel[loc name, loc src] getMethodHoldingDeclerationsFromM3(M3 model){
	return {<name,src> | <loc name, loc src> <- model.declarations, canContainMethods(name) && !isAnonymousClass(name)};
}

public rel[loc name, loc src] getMethodsFromM3(M3 model){
	return {<name,src> | <loc name, loc src> <- model.declarations, isMethod(name)};
}
