module visualization::Components::Dashboard

import IO;
import String;
import List;
import Map;

import structs::Visualization;
import visualization::Charts::Bar;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

import util::Math;

import vis::Figure;
import vis::Render;

FProperty titleColor = fontColor(rgb(0,0,0));
FProperty titleSize = fontSize(20);

FProperty subTitleColor = fontColor(rgb(0,0,0));
FProperty subTitleSize = fontSize(15);

public list[Figure] title(loc project) {
	return [];
}


private Figure titleBox(str title, str subTitle) {
	sthsth = text(title, titleSize, titleColor);
	sthsth2 = text(subTitle, subTitleSize, subTitleColor);
	return vcat([ sthsth, sthsth2 ]);
}

public list[Figure] general(ProjectData projectData) {
	return [
		box(titleBox("Volume", toString(projectData.metrics.volume)), fillColor("Red")),
		box(titleBox("Files", toString(15)), resizable(false), size(150, 50)),
		box(titleBox("Functions", toString(projectData.numberOfUnits)))
	];
}

public Figure renderDashboard(ProjectData projectData) {
	row1 = general(projectData);
	
	row2 = [ renderPercentageBar(projectData.metrics.percentages.duplication),
	         renderPercentageBar(projectData.metrics.percentages.unitTestCoverage)
	       ];
	       
	return grid([row1, row2]);
}