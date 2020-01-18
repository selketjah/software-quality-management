module resource::IO

import util::Resources;

import analysers::LocAnalyser;

public list[loc] listFiles(Resource currentProjectResource) {
	return [ a | /file(a) <- currentProjectResource, isJavaFile(a) ];
}

public set[loc] listMethods(Resource currentProjectResource) {
	return { a | /file(a) <- currentProjectResource, isJavaFile(a) && isMethod(a) };
}