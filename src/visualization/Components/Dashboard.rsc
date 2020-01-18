module visualization::Components::Dashboard

import IO;
import List;
import Message;
import Set;
import Map;
import Relation;
import String;

import structs::Visualization;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;
import structs::Rank;
import structs::Maintainability;

import util::Math;

import vis::Figure;
import vis::Render;

FProperty titleColor = fontColor(rgb(143,190,0));
FProperty subTitleColor = fontColor(rgb(108,120,142));

Color rightSideColor = rgb(143,190,0);
Color leftSideColor = rgb(241,235,235);

public Figure header(loc project, Rank projectRank) {
	projectTitle = text("OVERALL SCORE:", fontSize(20), titleColor);
	rankTitle = text(convertRankToLiteral(projectRank), fontSize(20), titleColor);
	return hcat([projectTitle, rankTitle], resizable(false), size(250, 75));
}

public Figure rankBox(str amount, str measurementSign, str bottomText, Rank rank) {
	amountTitle = text(amount, fontSize(20), titleColor);
	measurement = text(measurementSign, fontSize(10), titleColor);
	information = hcat([amountTitle, measurement], resizable(false), size(120, 25));
	
	subtitle = text(bottomText, resizable(false), size(100, 25), subTitleColor);
	together = vcat([information, subtitle], gap(5), center());
	b1 = box(together, resizable(false), size(200, 75), fillColor(leftSideColor), lineColor(leftSideColor));
	
	rankingText = text(convertRankToLiteral(rank), fontSize(20), subTitleColor);
	b2 = box(rankingText, fillColor(rightSideColor), lineColor(rightSideColor), resizable(false), size(75, 75));
	return hcat([b1, b2], resizable(false), size(275, 75));
}

public Figure ranking(ProjectData projectData) {
	volume = rankBox(toString(projectData.metrics.volume), "LOC", "VOLUME", projectData.ranks.volume);
	averageUnitSize = rankBox(toString(projectData.averages.size), "AVERAGE", "UNIT SIZE", projectData.ranks.unitSize);
	averageComplexity = rankBox(toString(projectData.averages.complexity), "AVERAGE", "COMPLEXITY", projectData.ranks.complexity);
	duplicationPercentage = rankBox(toString(projectData.metrics.percentages.duplication), "%", "DUPLICATION", projectData.ranks.duplication);
	unitTestCoveragePercentage = rankBox(toString(projectData.metrics.percentages.unitTestCoverage), "%", "UNIT TEST COVERAGE", projectData.ranks.unitTestCoverage);
	
	return hcat([volume, averageUnitSize, averageComplexity, duplicationPercentage, unitTestCoveragePercentage], gap(1));
}

public Figure maintainabilityBox(str bottomText, Rank rank, Color light, Color dark) {
	rankingText = text(convertRankToLiteral(rank), fontSize(20), fontColor(dark));	
	b1 = box(rankingText, resizable(false), size(300, 75), fillColor(light), lineColor(light), shadow(true));
	
	bottomTextTitle = text(bottomText, resizable(false), size(300, 25), subTitleColor);
	b2 = box(bottomTextTitle, fillColor(dark), lineColor(dark), resizable(false), size(300, 25), shadow(true));
	return vcat([b1, b2], resizable(false), size(300, 25));
}

public Figure maintainabilityBoxes(map[MaintainabilityCharacteristic, Rank] maintainability) {
	row1 = [ maintainabilityBox("ANALYSABILITY", maintainability[\analysability()], rgb(255,245,0), rgb(211, 204, 6)),
			 maintainabilityBox("CHANGEABILITY", maintainability[\changeability()], rgb(255,119,0), rgb(211,103, 4)) ];
			 
	row2 = [ maintainabilityBox("STABILITY", maintainability[\stability()], rgb(249, 2, 10), rgb(204, 2, 8)),
			 maintainabilityBox("TESTABILITY", maintainability[\testability()], rgb(2, 245, 249), rgb(3, 185, 188)) ];
	
	return grid([ row1, row2 ]);
}

public Figure maintainabilityScores(ProjectData projectData) {
	mainTitle = text("MAINTAINABILITY SCORES", fontSize(12), titleColor);
	b1 = box(mainTitle, resizable(false), size(650, 35), fillColor(leftSideColor), lineColor(rightSideColor));
	
	boxes = maintainabilityBoxes(projectData.ranks.maintainability);
	b2 = box(boxes, resizable(false), size(650, 500), fillColor(leftSideColor), lineColor(rightSideColor));
	
	return vcat([ b1, b2 ], resizable(false));
}

public Figure renderDashboard(ProjectData projectData) {
	row0 = header(projectData.project, projectData.ranks.overall);
	row1 = ranking(projectData);
	row2 = maintainabilityScores(projectData);
     
	return vcat( [ row0, row1, row2 ]);
}