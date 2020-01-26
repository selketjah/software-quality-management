module Cache::ProjectCache

import IO;
import ValueIO;
import structs::Analysis;
import structs::Ranking;
import structs::Average;
import structs::Percentage;
import structs::UnitTestCoverage;

public tuple[Metrics metrics, rel[loc, loc] duplicationRelationships, rel[loc name,loc src] methods, int volume, Percentages percentages, UnitTestCoverageMap unitTestCoverageMap] loadProjectData(loc project){
	return readTextValueFile(#tuple[Metrics metrics, rel[loc, loc] duplicationRelationships, rel[loc name,loc src] methods, int volume, Percentages percentages, UnitTestCoverageMap unitTestCoverageMap], generateProjectDataFileLocation(project));
}

public bool wasAlreadyCalculated(loc project){
	return exists(generateProjectDataFileLocation(project));
}

public loc generateProjectDataFileLocation(loc project){
	loc dataFolder = |home:///ou-sqm|;
	return dataFolder+project.authority+"data.sqm";
}

public void saveProjectData(loc project, tuple[Metrics metrics, rel[loc, loc] duplicationRelationships, rel[loc name,loc src] methods, int volume, Percentages percentages, UnitTestCoverageMap unitTestCoverageMap] projectData){
	writeTextValueFile(generateProjectDataFileLocation(project), projectData);
}